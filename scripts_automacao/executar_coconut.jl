"""
executar_coconut.jl
-------------------
Parte 2 — Bateria COCONUT
Executa APENAS os problemas com f* definido (status=2 viável).
Calcula gap de otimalidade e captura métricas de infeasibility.

Uso:
    julia scripts_automacao/executar_coconut.jl Ipopt
    julia scripts_automacao/executar_coconut.jl MadNLP
    julia scripts_automacao/executar_coconut.jl NLopt
    julia scripts_automacao/executar_coconut.jl UnoSolver
    julia scripts_automacao/executar_coconut.jl Optim

Saída:
    resultados/resultados_coconut.csv
"""

using JuMP
using CSV
using DataFrames
using Dates

# ── Configurações ──────────────────────────────────────────────────────────────
const DIR_RAIZ       = dirname(dirname(abspath(@__FILE__)))
const PASTA_MODELOS  = joinpath(DIR_RAIZ, "modelos_jump_gams")
const ARQ_RESULTADOS = joinpath(DIR_RAIZ, "resultados", "resultados_coconut.csv")
const ARQ_FSTAR      = joinpath(DIR_RAIZ, "gabarito_limpo.csv")
const TEMPO_LIMITE   = 300.0
# ──────────────────────────────────────────────────────────────────────────────

if length(ARGS) == 0
    println("❌ Uso: julia scripts_automacao/executar_coconut.jl <solver>")
    println("   Solvers: Ipopt | MadNLP | NLopt | UnoSolver | Optim")
    exit(1)
end

SOLVER_NOME = ARGS[1]

println("=" ^ 60)
println("NLP BENCHMARK — COCONUT — Solver: $SOLVER_NOME")
println("Data/Hora : $(now())")
println("Raiz      : $DIR_RAIZ")
println("=" ^ 60)

# ── Carregamento isolado do solver ────────────────────────────────────────────
if SOLVER_NOME == "Ipopt"
    import Ipopt
    otimizador = optimizer_with_attributes(
        Ipopt.Optimizer,
        "print_level"      => 0,
        "max_iter"         => 5000,
        "tol"              => 1e-6,
        "dual_inf_tol"     => 1.0,
        "constr_viol_tol"  => 1e-4,
        "acceptable_tol"   => 1e-2,
        "acceptable_iter"  => 15,
    )

elseif SOLVER_NOME == "MadNLP"
    import MadNLP
    otimizador = optimizer_with_attributes(
        MadNLP.Optimizer,
        "print_level" => MadNLP.ERROR,
        "max_iter"    => 5000,
        "tol"         => 1e-6,
    )

elseif SOLVER_NOME == "NLopt"
    import NLopt
    otimizador = optimizer_with_attributes(
        NLopt.Optimizer,
        "algorithm" => :LD_MMA
    )

elseif SOLVER_NOME == "UnoSolver"
    import UnoSolver
    otimizador = optimizer_with_attributes(
        UnoSolver.Optimizer,
        "preset" => "filtersqp"
    )

elseif SOLVER_NOME == "Optim"
    import Ipopt
    otimizador = optimizer_with_attributes(
        Ipopt.Optimizer,
        "print_level"    => 0,
        "max_iter"       => 5000,
        "tol"            => 1e-6,
        "dual_inf_tol"   => 1.0,
        "acceptable_tol" => 1e-2,
    )
    println("⚠️  Optim não tem wrapper JuMP nativo — usando Ipopt como proxy.")
    global SOLVER_NOME = "Optim(proxy=Ipopt)"

else
    println("❌ Solver desconhecido: $SOLVER_NOME")
    exit(1)
end

# ── Carrega f* e filtra só problemas com solução viável ──────────────────────
fstar_dict = Dict{String, Float64}()

if isfile(ARQ_FSTAR)
    df_fstar = CSV.read(ARQ_FSTAR, DataFrame;
                    missingstring="",
                    header=["Model","Best_Solution"],
                    skipto=2)

    # Detecta colunas
    col_nome  = findfirst(c -> lowercase(string(c)) in ["model","name","problema"], names(df_fstar))
    col_fstar = findfirst(c -> lowercase(string(c)) in ["best_solution","f_star","fstar","obj"], names(df_fstar))

    if !isnothing(col_nome) && !isnothing(col_fstar)
        for row in eachrow(df_fstar)
            nome = strip(string(row[col_nome]))
            val  = tryparse(Float64, strip(string(row[col_fstar])))
            # Só inclui se tiver f* definido (status=2 viável)
            if !isnothing(val) && !isempty(nome) && nome != "missing"
                fstar_dict[nome] = val
            end
        end
        println("📊 Problemas com f* (status=2): $(length(fstar_dict))")
    else
        println("⚠️  Colunas não identificadas em: $ARQ_FSTAR")
        println("   Colunas encontradas: $(names(df_fstar))")
    end
else
    println("⚠️  Arquivo não encontrado: $ARQ_FSTAR")
    println("   Rodando em todos os problemas sem filtro de f*.")
end

# ── Função gap de otimalidade ─────────────────────────────────────────────────
function gap_otimalidade(f_solver::Float64, f_star::Float64)::Float64
    (isnan(f_solver) || isnan(f_star)) && return NaN
    return abs(f_solver - f_star) / (1.0 + abs(f_star))
end

# ── Prepara resultados ────────────────────────────────────────────────────────
mkpath(joinpath(DIR_RAIZ, "resultados"))

if !isfile(ARQ_RESULTADOS)
    CSV.write(ARQ_RESULTADOS, DataFrame(
        Problema             = String[],
        Solver               = String[],
        Status               = String[],
        Tempo_Segundos       = Float64[],
        Valor_Objetivo       = Float64[],
        F_Star               = Float64[],
        Gap                  = Float64[],
        Dual_Infeasibility   = Float64[],
        Primal_Infeasibility = Float64[],
        Iteracoes            = Int[],
        Timestamp            = String[]
    ))
    println("📄 Arquivo criado: $ARQ_RESULTADOS")
end

df_existente  = CSV.read(ARQ_RESULTADOS, DataFrame; missingstring="NaN")
ja_executados = Set(zip(df_existente.Problema, df_existente.Solver))

# ── Lista arquivos — APENAS os que têm f* ────────────────────────────────────
if !isdir(PASTA_MODELOS)
    println("❌ Pasta não encontrada: $PASTA_MODELOS")
    exit(1)
end

todos_arquivos = sort(filter(x -> endswith(x, ".jl"), readdir(PASTA_MODELOS)))

# Filtra só os problemas com f* definido (se gabarito disponível)
arquivos_jl = if !isempty(fstar_dict)
    filter(f -> haskey(fstar_dict, replace(f, ".jl" => "")), todos_arquivos)
else
    todos_arquivos  # sem filtro se não tiver gabarito
end

if isempty(arquivos_jl)
    println("❌ Nenhum problema com f* encontrado!")
    println("   Verifique se os nomes no gabarito_limpo.csv batem com os arquivos .jl")
    exit(1)
end

total      = length(arquivos_jl)
ok_count   = 0
err_count  = 0
skip_count = 0

println("📂 Pasta            : $PASTA_MODELOS")
println("📄 Problemas c/ f*  : $total / $(length(todos_arquivos)) total")
println("💾 Resultados       : $ARQ_RESULTADOS\n")

# ── Loop principal ────────────────────────────────────────────────────────────
for (i, arquivo) in enumerate(arquivos_jl)
    global ok_count, err_count, skip_count

    caminho_arquivo = joinpath(PASTA_MODELOS, arquivo)
    nome_problema   = replace(arquivo, ".jl" => "")

    if (nome_problema, SOLVER_NOME) in ja_executados
        skip_count += 1
        println("[$i/$total] ⏩ $nome_problema — já executado")
        continue
    end

    print("[$i/$total] ⚙️  $nome_problema ... ")
    flush(stdout)

    status_final   = "FALHA_DESCONHECIDA"
    tempo_execucao = 0.0
    obj_val        = NaN
    dual_inf       = NaN
    primal_inf     = NaN
    iteracoes      = 0
    f_star         = get(fstar_dict, nome_problema, NaN)
    gap            = NaN

    try
        include(caminho_arquivo)
        set_optimizer(model, otimizador)
        set_time_limit_sec(model, 300.0)

        tempo_execucao = @elapsed optimize!(model)
        status_final   = string(termination_status(model))

        if has_values(model)
            obj_val = objective_value(model)
            gap     = gap_otimalidade(obj_val, f_star)
        end

        # Captura métricas de infeasibility
        try dual_inf   = MOI.get(model, MOI.DualObjectiveValue())   catch; end
        try primal_inf = MOI.get(model, MOI.ConstraintPrimalStart()) catch; end
        try
            iteracoes = MOI.get(model, MOI.SimplexIterations())
        catch
            try iteracoes = MOI.get(model, MOI.BarrierIterations()) catch; end
        end

    catch e
        status_final   = "ERRO: $(typeof(e))"
        tempo_execucao = 300.0
        msg = sprint(showerror, e)
        println("\n  ⚠️  $(msg[1:min(150, length(msg))])")
    end

    CSV.write(ARQ_RESULTADOS, DataFrame(
        Problema             = [nome_problema],
        Solver               = [SOLVER_NOME],
        Status               = [status_final],
        Tempo_Segundos       = [tempo_execucao],
        Valor_Objetivo       = [obj_val],
        F_Star               = [f_star],
        Gap                  = [gap],
        Dual_Infeasibility   = [dual_inf],
        Primal_Infeasibility = [primal_inf],
        Iteracoes            = [iteracoes],
        Timestamp            = [string(now())]
    ); append=true)

    ok = occursin("OPTIMAL", status_final) || occursin("LOCALLY_SOLVED", status_final)
    ok ? (ok_count += 1) : (err_count += 1)

    gap_str = isnan(gap) ? "—" : string(round(gap, digits=6))
    println("$(ok ? "✅" : "❌") $status_final | obj=$(round(obj_val, digits=4)) | gap=$gap_str | t=$(round(tempo_execucao, digits=3))s")
end

println("\n" * "=" ^ 60)
println("SOLVER $SOLVER_NOME — COCONUT FINALIZADO")
println("  ✅ Convergiu : $ok_count")
println("  ❌ Falhou    : $err_count")
println("  ⏩ Pulados   : $skip_count")
println("  📄 Resultados: $ARQ_RESULTADOS")
println("=" ^ 60)
