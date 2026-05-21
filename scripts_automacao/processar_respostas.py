"""
processar_respostas.py
----------------------
Lê os arquivos de resposta do Claude (respostas_claude/lote_NN_resposta.txt)
e separa cada modelo em um arquivo .jl individual em modelos_jump/.

Uso:
    python processar_respostas.py
"""

import os
import re
from pathlib import Path

PASTA_RESPOSTAS = "respostas_claude"
PASTA_SAIDA     = "modelos_jump"

Path(PASTA_SAIDA).mkdir(parents=True, exist_ok=True)

def limpar_codigo(texto: str) -> str:
    """Remove blocos markdown e espaços extras."""
    texto = re.sub(r"^```[a-zA-Z]*\n?", "", texto, flags=re.MULTILINE)
    texto = re.sub(r"^```\s*$", "", texto, flags=re.MULTILINE)
    return texto.strip()

def processar_arquivo(caminho: Path) -> int:
    conteudo = caminho.read_text(encoding="utf-8", errors="ignore")

    # Divide nos separadores ### NOME.jl
    blocos = re.split(r"###\s+([\w\-\.]+\.jl)", conteudo)
    # blocos = [texto_antes, nome1, codigo1, nome2, codigo2, ...]

    salvos = 0
    i = 1
    while i + 1 < len(blocos):
        nome  = blocos[i].strip()
        codigo = limpar_codigo(blocos[i + 1])

        if codigo:
            saida = Path(PASTA_SAIDA) / nome
            saida.write_text(
                f"# Gerado a partir de: {caminho.name}\n"
                f"# Modelo: {nome}\n\n"
                + codigo + "\n",
                encoding="utf-8"
            )
            print(f"  ✅ {nome}")
            salvos += 1
        i += 2

    return salvos

def main():
    pasta = Path(PASTA_RESPOSTAS)
    if not pasta.exists():
        print(f"❌ Pasta '{PASTA_RESPOSTAS}' não encontrada.")
        print("   Salve as respostas do Claude lá antes de rodar este script.")
        return

    arquivos = sorted(pasta.glob("lote_*_resposta.txt"))
    if not arquivos:
        print(f"❌ Nenhum arquivo lote_NN_resposta.txt encontrado em {PASTA_RESPOSTAS}/")
        return

    total = 0
    for arq in arquivos:
        print(f"\n📄 Processando: {arq.name}")
        n = processar_arquivo(arq)
        print(f"   {n} modelo(s) extraído(s)")
        total += n

    print(f"\n{'─'*50}")
    print(f"  ✅ Total de modelos .jl gerados: {total}")
    print(f"  📁 Pasta de saída: {Path(PASTA_SAIDA).resolve()}")
    print(f"{'─'*50}")

if __name__ == "__main__":
    main()
