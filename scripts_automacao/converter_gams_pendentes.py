"""
converter_gams_pendentes.py
---------------------------
Converte arquivos .gms de dados_gams/ que ainda NÃO têm arquivo
correspondente em modelos_jump_gams/ para Julia usando JuMP.

Regras de geração:
  - apenas: using JuMP  (sem imports de solvers)
  - model = Model()     (sem solver)
  - SEM optimize! no final
"""

import os
import time
from pathlib import Path
import anthropic

CHAVE_API  = os.environ.get("ANTHROPIC_API_KEY", "")
ORIGEM     = Path("dados_gams")
DESTINO    = Path("modelos_jump_gams")
MODELO     = "claude-sonnet-4-6"
PAUSA_SEG  = 3

PROMPT_SISTEMA = """\
Você é um especialista em otimização matemática. Vou te passar o conteúdo de um arquivo GAMS (.gms).
Converta o modelo exato para Julia usando o pacote JuMP, seguindo ESTRITAMENTE as regras:

1. Retorne APENAS código Julia — sem explicações, sem blocos markdown (sem ```julia).
2. Primeira linha obrigatória: using JuMP
3. Terceira linha (após linha em branco): model = Model()
4. NÃO adicione using para nenhum solver (não use Ipopt, HiGHS, GLPK, etc.).
5. NÃO chame optimize! em nenhum momento.
6. Inclua variáveis com @variable, restrições com @constraint e objetivo com @objective.
7. Preserve bounds e valores iniciais (start=...) quando presentes.
8. Converta: sqr(x) → x^2 | sqrt(x) → sqrt(x) | exp(x) → exp(x) | log(x) → log(x).
9. =E= → ==  |  =L= → <=  |  =G= → >=
"""

cliente = anthropic.Anthropic(api_key=CHAVE_API)


def pendentes() -> list[Path]:
    existentes = {f.stem for f in DESTINO.glob("*.jl")}
    return sorted(f for f in ORIGEM.glob("*.gms") if f.stem not in existentes)


def converter(arquivo: Path) -> str | None:
    conteudo = arquivo.read_text(encoding="utf-8", errors="ignore")
    try:
        resp = cliente.messages.create(
            model=MODELO,
            max_tokens=8192,
            system=PROMPT_SISTEMA,
            messages=[{"role": "user", "content":
                f"Converta o arquivo GAMS a seguir para JuMP:\n\n{conteudo}"}],
        )
        codigo = resp.content[0].text.strip()
        # Remove cerca markdown residual
        if codigo.startswith("```"):
            linhas = codigo.splitlines()
            codigo = "\n".join(linhas[1:] if linhas[-1] != "```" else linhas[1:-1])
        return codigo
    except anthropic.RateLimitError:
        print("  ⚠ rate-limit — aguardando 60 s...")
        time.sleep(60)
        return None
    except Exception as e:
        print(f"  ✗ erro API: {e}")
        return None


def main():
    if not CHAVE_API:
        raise SystemExit("Configure ANTHROPIC_API_KEY antes de rodar.")

    DESTINO.mkdir(parents=True, exist_ok=True)
    fila = pendentes()
    total = len(fila)
    print(f"Arquivos pendentes: {total}\n")

    ok = falha = 0
    for i, arq in enumerate(fila, 1):
        print(f"[{i:3d}/{total}] {arq.name} ...", end=" ", flush=True)
        codigo = converter(arq)
        if codigo:
            (DESTINO / f"{arq.stem}.jl").write_text(codigo + "\n", encoding="utf-8")
            print("✓")
            ok += 1
        else:
            print("✗")
            falha += 1
        if i < total:
            time.sleep(PAUSA_SEG)

    print(f"\nConvertidos: {ok}  |  Falhas: {falha}")


if __name__ == "__main__":
    main()
