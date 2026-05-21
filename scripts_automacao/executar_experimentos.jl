"""
executar_experimentos.jl
------------------------
Executa a bateria de testes NLP para UM solver por vez.

IMPORTANTE: Os arquivos .jl em modelos_jump/ devem conter APENAS
o modelo (variáveis, restrições, objetivo) sem optimize! no final.
O script injeta o solver e chama optimize! automaticamente.

Uso — rode cada solver em uma sessão Julia separada:
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
# Caminhos absolutos baseados na localização do script (funciona de qualquer pasta)
const DIR_RAIZ         = dirname(dirname(abspath(@__FILE__)))
const PASTA_MODELOS    = joinpath(DIR_RAIZ, "modelos_jump")
const ARQ_RESULTADOS   = joinpath(DIR_RAIZ, "resultados", "resultados_ampl.csv")
const TEMPO_LIMITE     = 300.0   # 5 minutos por problema (hardcoded — não usar variável global)
# ──────────────────────────────────────────────────────────────────────────────

# Verifica se o solver foi passado no terminal
if length(ARGS) == 0
    println("❌ Erro: informe o solver no terminal.")
    println("   Uso: julia scripts_automacao/executar_experimentos.jl <solver>")
    println("   Solvers: Ipopt | MadNLP | NLopt | UnoSolver | Optim")
    exit(1)
end

SOLVER_NOME = ARGS[1]

println("=" ^ 60)
println("NLP BENCHMARK — Solver: $SOLVER_NOME")
println("Data/Hora : $(now())")
println("Raiz      : $DIR_RAIZ")
println("=" ^ 60)

# ── Carregamento isolado do solver ────────────────────────────────────────────
if SOLVER_NOME == "Ipopt"
    import Ipopt
    otimizador = optimizer_with_attributes(
        Ipopt.Optimizer,
        "print_level" => 0,
        "max_iter"    => 5000
    )

elseif SOLVER_NOME == "MadNLP"
    import MadNLP
    otimizador = optimizer_with_attributes(
        MadNLP.Optimizer,
        "print_level" => MadNLP.ERROR,
        "max_iter"    => 5000
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
        "print_level" => 0,
        "max_iter"    => 5000
    )
    println("⚠️  Optim não tem wrapper JuMP nativo — usando Ipopt como proxy.")
    global SOLVER_NOME = "Optim(proxy=Ipopt)"

else
    println("❌ Solver desconhecido: $SOLVER_NOME")
    println("   Use: Ipopt | MadNLP | NLopt | UnoSolver | Optim")
    exit(1)
end

# ── Prepara pasta e arquivo de resultados ─────────────────────────────────────
mkpath(joinpath(DIR_RAIZ, "resultados"))

if !isfile(ARQ_RESULTADOS)
    CSV.write(ARQ_RESULTADOS, DataFrame(
        Problema       = String[],
        Solver         = String[],
        Status         = String[],
        Tempo_Segundos = Float64[],
        Valor_Objetivo = Float64[],
        Timestamp      = String[]
    ))
    println("📄 Arquivo criado: $ARQ_RESULTADOS")
end

# Carrega execuções já feitas para retomar de onde parou
df_existente  = CSV.read(ARQ_RESULTADOS, DataFrame; missingstring="NaN")
ja_executados = Set(zip(df_existente.Problema, df_existente.Solver))

# ── Lista arquivos .jl ────────────────────────────────────────────────────────
if !isdir(PASTA_MODELOS)
    println("❌ Pasta não encontrada: $PASTA_MODELOS")
    exit(1)
end

arquivos_jl = sort(filter(x -> endswith(x, ".jl"), readdir(PASTA_MODELOS)))

if isempty(arquivos_jl)
    println("❌ Nenhum arquivo .jl encontrado em: $PASTA_MODELOS")
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

    # Pula se já executado com este solver
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

    try
        # O include cria o model internamente
        include(caminho_arquivo)

        # Injeta o solver e o limite de tempo
        set_optimizer(model, otimizador)
        set_time_limit_sec(model, 300.0)

        # Executa e mede o tempo
        tempo_execucao = @elapsed optimize!(model)
        status_final   = string(termination_status(model))

        if has_values(model)
            obj_val = objective_value(model)
        end

    catch e
        status_final   = "ERRO: $(typeof(e))"
        tempo_execucao = 300.0
        msg = sprint(showerror, e)
        println("\n  ⚠️  $(msg[1:min(150, length(msg))])")
    end

    # Salva imediatamente no CSV
    CSV.write(ARQ_RESULTADOS, DataFrame(
        Problema       = [nome_problema],
        Solver         = [SOLVER_NOME],
        Status         = [status_final],
        Tempo_Segundos = [tempo_execucao],
        Valor_Objetivo = [obj_val],
        Timestamp      = [string(now())]
    ); append=true)

    ok = occursin("OPTIMAL", status_final) || occursin("LOCALLY_SOLVED", status_final)
    ok ? (ok_count += 1) : (err_count += 1)
    println("$(ok ? "✅" : "❌") $status_final | obj=$(round(obj_val, digits=6)) | t=$(round(tempo_execucao, digits=3))s")
end

# ── Resumo final ──────────────────────────────────────────────────────────────
println("\n" * "=" ^ 60)
println("SOLVER $SOLVER_NOME — SESSÃO FINALIZADA")
println("  ✅ Convergiu : $ok_count")
println("  ❌ Falhou    : $err_count")
println("  ⏩ Pulados   : $skip_count")
println("  📄 Resultados: $ARQ_RESULTADOS")
println("=" ^ 60)
