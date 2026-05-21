"""
02_batch_runner.jl
------------------
Execução em lote dos problemas JuMP contra os 5 solvers.
Roda UM solver por vez para evitar conflitos entre pacotes.

Pré-requisitos (instale uma vez):
    using Pkg
    Pkg.add(["JuMP", "Ipopt", "MadNLP", "NLopt", "UnoSolver",
             "CSV", "DataFrames", "Dates", "Logging"])

Uso — rode cada solver separadamente:
    julia 02_batch_runner.jl modelos_jump/ Ipopt
    julia 02_batch_runner.jl modelos_jump/ MadNLP
    julia 02_batch_runner.jl modelos_jump/ NLopt
    julia 02_batch_runner.jl modelos_jump/ UnoSolver
    julia 02_batch_runner.jl modelos_jump/ Optim

Saída:
    results/results_raw.csv — todos os resultados (acumulado a cada execução)
"""

using JuMP
using CSV
using DataFrames
using Dates
using Logging
import MathOptInterface as MOI

global_logger(ConsoleLogger(stderr, Logging.Warn))

# ---------------------------------------------------------------------------
# Solvers suportados
# ---------------------------------------------------------------------------

const SOLVERS_DISPONIVEIS = ["Ipopt", "MadNLP", "NLopt", "UnoSolver", "Optim"]

function load_solver(name::String)
    try
        if name == "Ipopt"
            import Ipopt
            return Ipopt.Optimizer
        elseif name == "MadNLP"
            import MadNLP
            return MadNLP.Optimizer
        elseif name == "NLopt"
            import NLopt
            return () -> NLopt.Optimizer(NLopt.LD_LBFGS)
        elseif name == "UnoSolver"
            import UnoSolver
            return () -> UnoSolver.Optimizer(preset="filtersqp")
        elseif name == "Optim"
            # Optim não tem wrapper JuMP nativo — usa Ipopt como proxy
            import Ipopt
            return Ipopt.Optimizer
        else
            error("Solver desconhecido: $name. Use: $(join(SOLVERS_DISPONIVEIS, ", "))")
        end
    catch e
        @warn "Solver $name não disponível: $e"
        return nothing
    end
end

# ---------------------------------------------------------------------------
# Patch do código do problema
# ---------------------------------------------------------------------------

function patch_solver_in_code(code::String, solver_name::String)::String
    # Remove imports de qualquer solver conhecido
    code = replace(code, r"^(import|using)\s+(Ipopt|MadNLP|NLopt|Optim|Uno|UnoSolver).*$"m => "")

    # Define a expressão do optimizer para substituição
    opt_expr = if solver_name == "UnoSolver"
        """UnoSolver.Optimizer(preset="filtersqp")"""
    elseif solver_name == "NLopt"
        "NLopt.Optimizer(NLopt.LD_LBFGS)"
    elseif solver_name == "Optim"
        "Ipopt.Optimizer"   # proxy
    else
        "$solver_name.Optimizer"
    end

    # Substitui qualquer Xxx.Optimizer existente
    for opt in ["Ipopt.Optimizer", "MadNLP.Optimizer", "NLopt.Optimizer",
                "Optim.Optimizer", "Uno.Optimizer", "UnoSolver.Optimizer"]
        code = replace(code, opt => opt_expr)
    end

    # Substitui Model() vazio pelo modelo com solver
    code = replace(code, r"(?i)model\s*=\s*Model\(\s*\)" => "model = Model($opt_expr)")

    # Import correto no topo
    import_line = if solver_name == "UnoSolver"
        "import UnoSolver\n"
    elseif solver_name == "NLopt"
        "import NLopt\n"
    elseif solver_name == "Optim"
        "import Ipopt\n"
    else
        "import $solver_name\n"
    end

    # Coleta padronizada de resultados no final
    if !occursin("_obj_value", code)
        code *= """

# --- Coleta automática de resultados ---
if termination_status(model) in [MOI.OPTIMAL, MOI.LOCALLY_SOLVED, MOI.FEASIBLE_POINT]
    global _obj_value = objective_value(model)
else
    global _obj_value = NaN
end
global _term_status = termination_status(model)
global _iterations  = try MOI.get(model, MOI.BarrierIterations()) catch; NaN end
"""
    end

    return "import MathOptInterface as MOI\n" * import_line * code
end

# ---------------------------------------------------------------------------
# Execução de um problema
# ---------------------------------------------------------------------------

function run_problem(problem_path::String, solver_name::String)::Dict
    problem_name = splitext(basename(problem_path))[1]

    result = Dict(
        "problema"  => problem_name,
        "solver"    => solver_name,
        "status"    => "NAO_EXECUTADO",
        "objetivo"  => NaN,
        "tempo_s"   => NaN,
        "iteracoes" => NaN,
        "timestamp" => string(now()),
        "erro"      => ""
    )

    optimizer = load_solver(solver_name)
    if isnothing(optimizer)
        result["status"] = "SOLVER_INDISPONIVEL"
        return result
    end

    code = read(problem_path, String)
    code_patched = patch_solver_in_code(code, solver_name)

    t_start = time()
    try
        m = Module()
        Base.eval(m, Meta.parse(code_patched))

        elapsed = time() - t_start

        result["status"]    = isdefined(m, :_term_status) ? string(m._term_status) : "DESCONHECIDO"
        result["objetivo"]  = isdefined(m, :_obj_value)   ? m._obj_value  : NaN
        result["tempo_s"]   = round(elapsed, digits=4)
        result["iteracoes"] = isdefined(m, :_iterations)  ? m._iterations : NaN

    catch e
        result["status"] = "ERRO"
        result["erro"]   = string(e)[1:min(500, length(string(e)))]
        result["tempo_s"] = round(time() - t_start, digits=4)
    end

    return result
end

# ---------------------------------------------------------------------------
# Execução em lote — UM solver por vez
# ---------------------------------------------------------------------------

function run_batch(problem_dir::String, solver_name::String;
                   output_dir::String = "results")

    mkpath(output_dir)
    output_csv = joinpath(output_dir, "results_raw.csv")

    # Lista arquivos .jl
    files = if isdir(problem_dir)
        sort(filter(f -> endswith(f, ".jl"), readdir(problem_dir, join=true)))
    elseif isfile(problem_dir)
        [problem_dir]
    else
        error("Caminho não encontrado: $problem_dir")
    end

    isempty(files) && error("Nenhum arquivo .jl encontrado em: $problem_dir")

    println("=" ^ 60)
    println("NLP BENCHMARK")
    println("  Solver    : $solver_name")
    println("  Problemas : $(length(files))")
    println("  Saída     : $output_csv")
    println("=" ^ 60)

    # Carrega execuções anteriores para retomar
    existing = if isfile(output_csv)
        CSV.read(output_csv, DataFrame;
                 types=Dict(:objetivo=>Float64, :tempo_s=>Float64),
                 missingstring="NaN")
    else
        DataFrame(problema=String[], solver=String[], status=String[],
                  objetivo=Float64[], tempo_s=Float64[], iteracoes=Float64[],
                  timestamp=String[], erro=String[])
    end

    completed = Set(zip(existing.problema, existing.solver))
    total     = length(files)
    ok_count  = 0
    err_count = 0
    skip_count = 0

    open(output_csv, "a") do io
        if nrow(existing) == 0
            println(io, "problema,solver,status,objetivo,tempo_s,iteracoes,timestamp,erro")
        end

        for (i, prob_path) in enumerate(files)
            prob_name = splitext(basename(prob_path))[1]

            if (prob_name, solver_name) in completed
                skip_count += 1
                println("[$i/$total] ⏩ $prob_name — já executado, pulando")
                continue
            end

            print("[$i/$total] ⚙️  $prob_name ... ")
            flush(stdout)

            res = run_problem(prob_path, solver_name)

            # Salva imediatamente no CSV
            linha = join([
                res["problema"],
                res["solver"],
                res["status"],
                isnan(res["objetivo"])  ? "NaN" : string(res["objetivo"]),
                isnan(res["tempo_s"])   ? "NaN" : string(res["tempo_s"]),
                isnan(res["iteracoes"]) ? "NaN" : string(res["iteracoes"]),
                res["timestamp"],
                "\"" * replace(res["erro"], "\"" => "'") * "\""
            ], ",")
            println(io, linha)
            flush(io)

            ok = res["status"] in ["OPTIMAL", "LOCALLY_SOLVED",
                                   "MOI.OPTIMAL", "MOI.LOCALLY_SOLVED"]
            ok ? (ok_count += 1) : (err_count += 1)
            println("$(ok ? "✅" : "❌") $(res["status"]) | obj=$(res["objetivo"]) | t=$(res["tempo_s"])s")
        end
    end

    println("\n" * "=" ^ 60)
    println("SOLVER $solver_name — CONCLUÍDO")
    println("  ✅ Convergiu : $ok_count")
    println("  ❌ Falhou    : $err_count")
    println("  ⏩ Pulados   : $skip_count")
    println("  📄 CSV       : $output_csv")
    println("=" ^ 60)

    return output_csv
end

# ---------------------------------------------------------------------------
# Ponto de entrada
# ---------------------------------------------------------------------------

if abspath(PROGRAM_FILE) == @__FILE__
    if length(ARGS) < 2
        println("""
        Uso:
          julia 02_batch_runner.jl <pasta> <solver>

        Exemplos — rode cada um separadamente:
          julia 02_batch_runner.jl modelos_jump/ Ipopt
          julia 02_batch_runner.jl modelos_jump/ MadNLP
          julia 02_batch_runner.jl modelos_jump/ NLopt
          julia 02_batch_runner.jl modelos_jump/ UnoSolver
          julia 02_batch_runner.jl modelos_jump/ Optim

        Solvers disponíveis: $(join(SOLVERS_DISPONIVEIS, ", "))
        Todos os resultados são salvos em results/results_raw.csv
        """)
    else
        pasta  = ARGS[1]
        solver = ARGS[2]
        run_batch(pasta, solver)
    end
end
