"""
executar_experimentos.jl
------------------------
Parte 1 — Bateria AMPL-NLP (47 problemas oficiais)
Executa UM solver por vez com captura de métricas detalhadas.

Uso:
    julia scripts_automacao/executar_experimentos.jl Ipopt
    julia scripts_automacao/executar_experimentos.jl MadNLP
    julia scripts_automacao/executar_experimentos.jl NLopt
    julia scripts_automacao/executar_experimentos.jl UnoSolver
    julia scripts_automacao/executar_experimentos.jl Optim

Saída:
    resultados/resultados_ampl.csv
"""

using JuMP
using CSV
using DataFrames
using Dates

# ── Configurações ──────────────────────────────────────────────────────────────
const DIR_RAIZ       = dirname(dirname(abspath(@__FILE__)))
const PASTA_MODELOS  = joinpath(DIR_RAIZ, "modelos_jump")
const ARQ_RESULTADOS = joinpath(DIR_RAIZ, "resultados", "resultados_ampl.csv")
const TEMPO_LIMITE   = 300.0
# ──────────────────────────────────────────────────────────────────────────────

if length(ARGS) == 0
    println("❌ Uso: julia scripts_automacao/executar_experimentos.jl <solver>")
    println("   Solvers: Ipopt | MadNLP | NLopt | UnoSolver | Optim")
    exit(1)
end

SOLVER_NOME = ARGS[1]

println("=" ^ 60)
println("NLP BENCHMARK — AMPL — Solver: $SOLVER_NOME")
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
        "tol"              => 1e-6,      # tolerância primal
        "dual_inf_tol"     => 1.0,       # tolerância dual infeasibility
        "constr_viol_tol"  => 1e-4,      # violação de restrição
        "acceptable_tol"   => 1e-2,      # tolerância aceitável (fallback)
        "acceptable_iter"  => 15,        # iterações com tolerância aceitável
    )

elseif SOLVER_NOME == "MadNLP"
    import MadNLP
    otimizador = optimizer_with_attributes(
        MadNLP.Optimizer,
        "print_level"  => MadNLP.ERROR,
        "max_iter"     => 5000,
        "tol"          => 1e-6,
    )

elseif SOLVER_NOME == "NLopt"
    import NLopt
    otimizador = optimizer_with_attributes(
        NLopt.Optimizer,
        "algorithm" => :LD_SLSQP
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
        "print_level"     => 0,
        "max_iter"        => 5000,
        "tol"             => 1e-6,
        "dual_inf_tol"    => 1.0,
        "acceptable_tol"  => 1e-2,
    )
    println("⚠️  Optim não tem wrapper JuMP nativo — usando Ipopt como proxy.")
    global SOLVER_NOME = "Optim(proxy=Ipopt)"

else
    println("❌ Solver desconhecido: $SOLVER_NOME")
    exit(1)
end

# ── Prepara resultados ────────────────────────────────────────────────────────
mkpath(joinpath(DIR_RAIZ, "resultados"))

if !isfile(ARQ_RESULTADOS)
    CSV.write(ARQ_RESULTADOS, DataFrame(
        Problema          = String[],
        Solver            = String[],
        Status            = String[],
        Tempo_Segundos    = Float64[],
        Valor_Objetivo    = Float64[],
        Dual_Infeasibility = Float64[],
        Primal_Infeasibility = Float64[],
        Iteracoes         = Int[],
        Timestamp         = String[]
    ))
    println("📄 Arquivo criado: $ARQ_RESULTADOS")
end

df_existente  = CSV.read(ARQ_RESULTADOS, DataFrame; missingstring="NaN")
ja_executados = Set(zip(df_existente.Problema, df_existente.Solver))

# ── Lista arquivos ────────────────────────────────────────────────────────────
if !isdir(PASTA_MODELOS)
    println("❌ Pasta não encontrada: $PASTA_MODELOS")
    exit(1)
end

arquivos_jl = sort(filter(x -> endswith(x, ".jl"), readdir(PASTA_MODELOS)))

if isempty(arquivos_jl)
    println("❌ Nenhum .jl encontrado em: $PASTA_MODELOS")
    exit(1)
end

total      = length(arquivos_jl)
ok_count   = 0
err_count  = 0
skip_count = 0

println("📂 Pasta     : $PASTA_MODELOS")
println("📄 Modelos   : $total arquivos")
println("💾 Resultados: $ARQ_RESULTADOS\n")

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

    status_final        = "FALHA_DESCONHECIDA"
    tempo_execucao      = 0.0
    obj_val             = NaN
    dual_inf            = NaN
    primal_inf          = NaN
    iteracoes           = 0

    try
        include(caminho_arquivo)
        set_optimizer(model, otimizador)
        set_time_limit_sec(model, 300.0)

        tempo_execucao = @elapsed optimize!(model)
        status_final   = string(termination_status(model))

        if has_values(model)
            obj_val = objective_value(model)
        end

        # Captura métricas de infeasibility
        try
            dual_inf   = MOI.get(model, MOI.DualObjectiveValue())
        catch; end
        try
            primal_inf = MOI.get(model, MOI.ConstraintPrimalStart())
        catch; end
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
        Dual_Infeasibility   = [dual_inf],
        Primal_Infeasibility = [primal_inf],
        Iteracoes            = [iteracoes],
        Timestamp            = [string(now())]
    ); append=true)

    ok = occursin("OPTIMAL", status_final) || occursin("LOCALLY_SOLVED", status_final)
    ok ? (ok_count += 1) : (err_count += 1)
    println("$(ok ? "✅" : "❌") $status_final | obj=$(round(obj_val, digits=4)) | t=$(round(tempo_execucao, digits=3))s")
end

println("\n" * "=" ^ 60)
println("SOLVER $SOLVER_NOME — AMPL FINALIZADO")
println("  ✅ Convergiu : $ok_count")
println("  ❌ Falhou    : $err_count")
println("  ⏩ Pulados   : $skip_count")
println("  📄 Resultados: $ARQ_RESULTADOS")
println("=" ^ 60)
