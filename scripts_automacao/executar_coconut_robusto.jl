"""
executar_coconut_robusto.jl
---------------------------
Versão robusta — cada problema roda em processo Julia separado.
Se o solver crashar, o processo filho morre e o pai continua.

Uso:
    julia scripts_automacao\executar_coconut_robusto.jl Ipopt
    julia scripts_automacao\executar_coconut_robusto.jl MadNLP
    julia scripts_automacao\executar_coconut_robusto.jl NLopt
    julia scripts_automacao\executar_coconut_robusto.jl UnoSolver
    julia scripts_automacao\executar_coconut_robusto.jl Optim
"""

using CSV
using DataFrames
using Dates

# ── Configurações ──────────────────────────────────────────────────────────────
const DIR_RAIZ       = dirname(dirname(abspath(@__FILE__)))
const PASTA_MODELOS  = joinpath(DIR_RAIZ, "modelos_jump_gams")
const ARQ_RESULTADOS = joinpath(DIR_RAIZ, "resultados", "resultados_coconut.csv")
const ARQ_FSTAR      = joinpath(DIR_RAIZ, "gabarito_solucoes.csv")
const TEMPO_LIMITE   = 3600  # segundos por problema (1 hora)
const JULIA_BIN      = joinpath(Sys.BINDIR, "julia")
# ──────────────────────────────────────────────────────────────────────────────

if length(ARGS) == 0
    println("Uso: julia executar_coconut_robusto.jl <solver>")
    println("Solvers: Ipopt | MadNLP | NLopt | UnoSolver | Optim")
    exit(1)
end

SOLVER_NOME = ARGS[1]

println("=" ^ 60)
println("NLP BENCHMARK ROBUSTO — COCONUT — Solver: $SOLVER_NOME")
println("Data/Hora  : $(now())")
println("Timeout    : $(TEMPO_LIMITE)s por problema")
println("=" ^ 60)

# ── Carrega f* ────────────────────────────────────────────────────────────────
fstar_dict = Dict{String, Float64}()
if isfile(ARQ_FSTAR)
    df = CSV.read(ARQ_FSTAR, DataFrame; missingstring="")
    col_nome  = findfirst(c -> lowercase(string(c)) in ["name","model","problema"], names(df))
    col_fstar = findfirst(c -> lowercase(string(c)) in ["best_solution","f_star","fstar","best","obj"], names(df))
    if !isnothing(col_nome) && !isnothing(col_fstar)
        for row in eachrow(df)
            val = tryparse(Float64, string(row[col_fstar]))
            if !isnothing(val)
                fstar_dict[string(row[col_nome])] = val
            end
        end
        println("📊 f* carregados: $(length(fstar_dict)) problemas")
    end
end

# ── Script Julia inline executado por cada processo filho ─────────────────────
function make_child_script(modelo_path::String, solver_nome::String)::String
    f = replace(modelo_path, "\\" => "\\\\")
    return """
import MathOptInterface as MOI
using JuMP

# Carrega solver
if "$solver_nome" == "Ipopt"
    import Ipopt
    otimizador = optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0, "max_iter" => 3000)
elseif "$solver_nome" == "MadNLP"
    import MadNLP
    otimizador = optimizer_with_attributes(MadNLP.Optimizer, "print_level" => MadNLP.ERROR, "max_iter" => 3000)
elseif "$solver_nome" == "NLopt"
    import NLopt
    otimizador = optimizer_with_attributes(NLopt.Optimizer, "algorithm" => :LD_SLSQP)
elseif "$solver_nome" == "UnoSolver"
    import UnoSolver
    otimizador = optimizer_with_attributes(UnoSolver.Optimizer, "preset" => "filtersqp")
elseif "$solver_nome" == "Optim"
    import Ipopt
    otimizador = optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0, "max_iter" => 3000)
end

include("$f")
set_optimizer(model, otimizador)
set_time_limit_sec(model, $TEMPO_LIMITE.0)
optimize!(model)

status = string(termination_status(model))
obj    = NaN
if has_values(model)
    obj = objective_value(model)
end
println("STATUS=\$status")
println("OBJ=\$obj")
"""
end

# ── Prepara CSV ───────────────────────────────────────────────────────────────
mkpath(joinpath(DIR_RAIZ, "resultados"))
if !isfile(ARQ_RESULTADOS)
    CSV.write(ARQ_RESULTADOS, DataFrame(
        Problema=String[], Solver=String[], Status=String[],
        Tempo_Segundos=Float64[], Valor_Objetivo=Float64[],
        F_Star=Float64[], Gap=Float64[], Timestamp=String[]
    ))
end

df_exist     = CSV.read(ARQ_RESULTADOS, DataFrame; missingstring="NaN")
ja_executados = Set(zip(df_exist.Problema, df_exist.Solver))

# ── Lista arquivos ────────────────────────────────────────────────────────────
arquivos = sort(filter(f -> endswith(f, ".jl"), readdir(PASTA_MODELOS)))
total    = length(arquivos)
ok_count = 0; err_count = 0; skip_count = 0

println("📂 Modelos: $total arquivos\n")

# ── Loop principal ────────────────────────────────────────────────────────────
for (i, arquivo) in enumerate(arquivos)
    global ok_count, err_count, skip_count

    nome    = replace(arquivo, ".jl" => "")
    caminho = joinpath(PASTA_MODELOS, arquivo)

    if (nome, SOLVER_NOME) in ja_executados
        skip_count += 1
        println("[$i/$total] ⏩ $nome — já executado")
        continue
    end

    print("[$i/$total] ⚙️  $nome ... ")
    flush(stdout)

    # Escreve script temporário
    tmp_script = tempname() * ".jl"
    write(tmp_script, make_child_script(caminho, SOLVER_NOME))

    status_final   = "TIMEOUT"
    obj_val        = NaN
    tempo_execucao = Float64(TEMPO_LIMITE)

    t_start = time()
    try
        # Roda em processo separado com timeout
        cmd = Cmd([JULIA_BIN, "--project=$(DIR_RAIZ)", tmp_script])
        buf = IOBuffer()
        proc = run(pipeline(cmd, stdout=buf, stderr=devnull), wait=false)

        # Aguarda com timeout
        deadline = time() + TEMPO_LIMITE + 30  # +30s de margem
        while process_running(proc) && time() < deadline
            sleep(1)
        end

        if process_running(proc)
            kill(proc)
            status_final = "TIMEOUT_KILL"
        else
            output = String(take!(buf))
            for line in split(output, "\n")
                if startswith(line, "STATUS=")
                    status_final = strip(line[8:end])
                elseif startswith(line, "OBJ=")
                    v = tryparse(Float64, strip(line[5:end]))
                    if !isnothing(v); obj_val = v; end
                end
            end
        end
    catch e
        status_final = "ERRO_PROCESSO"
    finally
        rm(tmp_script, force=true)
    end

    tempo_execucao = round(time() - t_start, digits=3)

    # Gap de otimalidade
    f_star = get(fstar_dict, nome, NaN)
    gap    = if !isnan(obj_val) && !isnan(f_star)
        abs(obj_val - f_star) / (1.0 + abs(f_star))
    else
        NaN
    end

    # Salva no CSV
    CSV.write(ARQ_RESULTADOS, DataFrame(
        Problema=[nome], Solver=[SOLVER_NOME], Status=[status_final],
        Tempo_Segundos=[tempo_execucao], Valor_Objetivo=[obj_val],
        F_Star=[f_star], Gap=[gap], Timestamp=[string(now())]
    ); append=true)

    ok = occursin("OPTIMAL", status_final) || occursin("LOCALLY_SOLVED", status_final)
    ok ? (ok_count += 1) : (err_count += 1)
    gap_str = isnan(gap) ? "—" : string(round(gap, digits=6))
    println("$(ok ? "✅" : "❌") $status_final | obj=$(round(obj_val,digits=4)) | gap=$gap_str | t=$(tempo_execucao)s")
end

println("\n" * "=" ^ 60)
println("SOLVER $SOLVER_NOME — FINALIZADO")
println("  ✅ Convergiu : $ok_count")
println("  ❌ Falhou    : $err_count")
println("  ⏩ Pulados   : $skip_count")
println("  📄 Resultados: $ARQ_RESULTADOS")
println("=" ^ 60)