"""
gerar_lotes.py
--------------
Gera arquivos de lote (.txt) prontos para colar no Claude manualmente.
Cada lote contém vários modelos AMPL (.mod) ou GAMS (.gms) com o prompt
já formatado — basta copiar, colar no claude.ai e salvar a resposta.

Uso:
    python gerar_lotes.py                          # lê dados_ampl/, lote de 5
    python gerar_lotes.py --origem problems/ampl   # pasta personalizada
    python gerar_lotes.py --lote 3                 # 3 arquivos por lote
    python gerar_lotes.py --ext gms                # só arquivos .gms
    python gerar_lotes.py --origem problems/ampl --lote 3 --ext mod

Saída:
    prompts_claude/
        lote_01.txt   ← copie e cole no Claude
        lote_02.txt
        ...
        instrucoes.txt ← como salvar as respostas
"""

import os
import argparse
from pathlib import Path
from datetime import datetime

# ─────────────────────────────────────────────────────────────────────────────
# Configuração padrão
# ─────────────────────────────────────────────────────────────────────────────

PASTA_ORIGEM   = "dados_ampl"
PASTA_DESTINO  = "prompts_claude"
TAMANHO_LOTE   = 5
EXTENSOES      = [".mod", ".gms"]

# ─────────────────────────────────────────────────────────────────────────────
# Prompt mestre — mesmo que o Claude receba o lote sem contexto, funciona
# ─────────────────────────────────────────────────────────────────────────────

def montar_prompt(arquivos_do_lote: list[dict], num_lote: int, total_lotes: int) -> str:
    n = len(arquivos_do_lote)
    formatos = set(a["ext"] for a in arquivos_do_lote)
    desc_formato = "AMPL (.mod)" if formatos == {".mod"} else \
                   "GAMS (.gms)" if formatos == {".gms"} else \
                   "AMPL (.mod) e GAMS (.gms)"

    cabecalho = f"""\
================================================================
LOTE {num_lote:02d} DE {total_lotes:02d}  |  {n} modelo(s)  |  Gerado em {datetime.now().strftime("%d/%m/%Y %H:%M")}
================================================================

Você é um especialista em otimização matemática.
Abaixo estão {n} modelo(s) escritos em {desc_formato}.
Converta cada um para Julia usando o pacote JuMP.

REGRAS ESTRITAS — siga exatamente:
1. Retorne APENAS código Julia. Zero explicações, zero texto fora do código.
2. Separe cada modelo com o cabeçalho exato:
       ### NOME_DO_ARQUIVO.jl
3. Cada código deve ser autocontido e executável:
   - Inclua os `using` necessários (JuMP, etc.)
   - NÃO defina o solver — use apenas: model = Model()
   - O solver será injetado automaticamente pelo script de execução.
4. Inclua TODAS as variáveis, restrições e a função objetivo do original.
5. Ao final de cada modelo, adicione exatamente estas 3 linhas:
       optimize!(model)
       println("Status: ", termination_status(model))
       println("Objetivo: ", objective_value(model))

----------------------------------------------------------------
MODELOS DESTE LOTE:
----------------------------------------------------------------

"""

    corpo = ""
    for arq in arquivos_do_lote:
        corpo += f"### [{arq['nome']}]\n\n"
        corpo += arq["conteudo"]
        corpo += "\n\n" + "─" * 64 + "\n\n"

    rodape = f"""\
================================================================
FIM DO LOTE {num_lote:02d}
Salve a resposta completa em: respostas_claude/lote_{num_lote:02d}_resposta.txt
================================================================
"""
    return cabecalho + corpo + rodape


# ─────────────────────────────────────────────────────────────────────────────
# Instruções de uso manual
# ─────────────────────────────────────────────────────────────────────────────

def gerar_instrucoes(total_lotes: int, destino: Path) -> str:
    return f"""\
================================================================
INSTRUÇÕES — Como usar os lotes no Claude
================================================================

PASSO 1 — Abra o Claude
   Acesse: https://claude.ai
   Use o modelo Claude Opus (mais capaz para código técnico).

PASSO 2 — Para cada lote (lote_01.txt até lote_{total_lotes:02d}.txt):
   a) Abra o arquivo do lote em qualquer editor de texto
   b) Selecione TUDO (Ctrl+A) e copie (Ctrl+C)
   c) Cole no campo de mensagem do Claude (Ctrl+V)
   d) Envie e aguarde a resposta completa

PASSO 3 — Salve a resposta
   a) Crie a pasta: respostas_claude/
   b) Copie a resposta inteira do Claude
   c) Salve como: respostas_claude/lote_01_resposta.txt
      (substitua 01 pelo número do lote correspondente)

PASSO 4 — Após salvar todos os lotes, execute:
   python processar_respostas.py
   Isso vai separar cada modelo em um arquivo .jl individual
   na pasta: modelos_jump/

================================================================
DICAS IMPORTANTES
================================================================

- Se o Claude parar no meio: peça "continue" ou "continue o código"
- Se o código vier com ```julia ... ```: o processador remove automaticamente
- Faça um lote por vez — não envie vários juntos
- Confira se a resposta tem todos os ### NOME.jl antes de salvar
- Total de lotes: {total_lotes}
- Pasta de destino dos lotes: {destino.resolve()}

================================================================
"""


# ─────────────────────────────────────────────────────────────────────────────
# Parser de respostas — separa cada ### NOME.jl em arquivo individual
# (salvo aqui para não precisar de script separado)
# ─────────────────────────────────────────────────────────────────────────────

def gerar_script_processador(destino: Path):
    """Gera o script processar_respostas.py junto com os lotes."""
    script = '''\
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
    texto = re.sub(r"^```[a-zA-Z]*\\n?", "", texto, flags=re.MULTILINE)
    texto = re.sub(r"^```\\s*$", "", texto, flags=re.MULTILINE)
    return texto.strip()

def processar_arquivo(caminho: Path) -> int:
    conteudo = caminho.read_text(encoding="utf-8", errors="ignore")

    # Divide nos separadores ### NOME.jl
    blocos = re.split(r"###\\s+([\\w\\-\\.]+\\.jl)", conteudo)
    # blocos = [texto_antes, nome1, codigo1, nome2, codigo2, ...]

    salvos = 0
    i = 1
    while i + 1 < len(blocos):
        nome  = blocos[i].strip()
        codigo = limpar_codigo(blocos[i + 1])

        if codigo:
            saida = Path(PASTA_SAIDA) / nome
            saida.write_text(
                f"# Gerado a partir de: {caminho.name}\\n"
                f"# Modelo: {nome}\\n\\n"
                + codigo + "\\n",
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
        print(f"\\n📄 Processando: {arq.name}")
        n = processar_arquivo(arq)
        print(f"   {n} modelo(s) extraído(s)")
        total += n

    print(f"\\n{'─'*50}")
    print(f"  ✅ Total de modelos .jl gerados: {total}")
    print(f"  📁 Pasta de saída: {Path(PASTA_SAIDA).resolve()}")
    print(f"{'─'*50}")

if __name__ == "__main__":
    main()
'''
    (destino.parent / "processar_respostas.py").write_text(script, encoding="utf-8")
    print("  📄 processar_respostas.py gerado.")


# ─────────────────────────────────────────────────────────────────────────────
# Função principal
# ─────────────────────────────────────────────────────────────────────────────

def criar_lotes(pasta_origem: str, pasta_destino: str,
                tamanho_lote: int, extensoes: list[str]):

    origem  = Path(pasta_origem)
    destino = Path(pasta_destino)

    if not origem.exists():
        print(f"❌ Pasta de origem não encontrada: {origem.resolve()}")
        return

    # Coleta arquivos
    arquivos = sorted([
        f for f in origem.iterdir()
        if f.suffix.lower() in extensoes
    ])

    if not arquivos:
        exts = ", ".join(extensoes)
        print(f"⚠️  Nenhum arquivo {exts} encontrado em: {origem}")
        return

    destino.mkdir(parents=True, exist_ok=True)

    total_arquivos = len(arquivos)
    total_lotes    = (total_arquivos + tamanho_lote - 1) // tamanho_lote

    print(f"\n📂 Origem  : {origem.resolve()}")
    print(f"📁 Destino : {destino.resolve()}")
    print(f"📄 Arquivos: {total_arquivos}")
    print(f"📦 Lotes   : {total_lotes} (de {tamanho_lote} arquivo(s) cada)\n")
    print("─" * 50)

    for i in range(total_lotes):
        inicio = i * tamanho_lote
        fim    = min(inicio + tamanho_lote, total_arquivos)
        grupo  = arquivos[inicio:fim]

        # Lê o conteúdo de cada arquivo do lote
        arquivos_do_lote = []
        for f in grupo:
            try:
                conteudo = f.read_text(encoding="utf-8", errors="ignore")
            except Exception as e:
                print(f"  ⚠️  Erro ao ler {f.name}: {e}")
                conteudo = f"# Erro ao ler arquivo: {e}"
            arquivos_do_lote.append({
                "nome"    : f.name,
                "ext"     : f.suffix.lower(),
                "conteudo": conteudo,
            })

        # Monta o prompt completo do lote
        prompt = montar_prompt(arquivos_do_lote, i + 1, total_lotes)

        # Salva o arquivo do lote
        caminho_lote = destino / f"lote_{i+1:02d}.txt"
        caminho_lote.write_text(prompt, encoding="utf-8")

        nomes = ", ".join(a["nome"] for a in arquivos_do_lote)
        print(f"  ✅ lote_{i+1:02d}.txt  →  {nomes}")

    # Salva instruções
    instrucoes = gerar_instrucoes(total_lotes, destino)
    (destino / "instrucoes.txt").write_text(instrucoes, encoding="utf-8")
    print(f"\n  📋 instrucoes.txt gerado.")

    # Gera o script processador de respostas
    gerar_script_processador(destino)

    # Cria pasta de respostas vazia
    (destino.parent / "respostas_claude").mkdir(exist_ok=True)

    print(f"\n{'─'*50}")
    print(f"  🎉 {total_lotes} lote(s) prontos em: {destino.resolve()}")
    print(f"\n  Próximos passos:")
    print(f"  1. Leia: {destino / 'instrucoes.txt'}")
    print(f"  2. Cole cada lote_NN.txt no Claude e salve a resposta")
    print(f"  3. Execute: python processar_respostas.py")
    print(f"{'─'*50}\n")


# ─────────────────────────────────────────────────────────────────────────────
# CLI
# ─────────────────────────────────────────────────────────────────────────────

def parse_args():
    p = argparse.ArgumentParser(
        description="Gera lotes de prompts para conversão manual no Claude.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemplos:
  python gerar_lotes.py
  python gerar_lotes.py --origem problems/ampl --lote 3
  python gerar_lotes.py --origem problems/coconut --ext gms
  python gerar_lotes.py --origem problems/ampl --destino meus_lotes --lote 10
        """
    )
    p.add_argument("--origem",  default=PASTA_ORIGEM,  help=f"Pasta com os .mod/.gms (padrão: {PASTA_ORIGEM})")
    p.add_argument("--destino", default=PASTA_DESTINO, help=f"Pasta de saída dos lotes (padrão: {PASTA_DESTINO})")
    p.add_argument("--lote",    type=int, default=TAMANHO_LOTE, help=f"Arquivos por lote (padrão: {TAMANHO_LOTE})")
    p.add_argument("--ext",     choices=["mod", "gms", "ambos"], default="ambos",
                   help="Extensão a filtrar: mod, gms ou ambos (padrão: ambos)")
    return p.parse_args()


if __name__ == "__main__":
    args  = parse_args()
    exts  = {
        "mod"  : [".mod"],
        "gms"  : [".gms"],
        "ambos": [".mod", ".gms"],
    }[args.ext]

    criar_lotes(args.origem, args.destino, args.lote, exts)
