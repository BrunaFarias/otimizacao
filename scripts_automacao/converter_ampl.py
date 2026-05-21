"""
converter_ampl.py
-----------------
Converte arquivos AMPL (.mod) e GAMS (.gms) para JuMP em Julia
usando a API da Anthropic (Claude).

Adaptado do script original com OpenAI para usar a API do Claude.

Uso:
    python converter_ampl.py                      # converte pasta dados_ampl/ inteira
    python converter_ampl.py --origem problems/ampl --destino converted
    python converter_ampl.py --arquivo hs001.mod  # arquivo único

Pré-requisito:
    pip install anthropic
"""

import os
import time
import argparse
from pathlib import Path
import anthropic

# ─────────────────────────────────────────────────────────────────────────────
# Configuração
# ─────────────────────────────────────────────────────────────────────────────

# Lê a chave da variável de ambiente (mais seguro que colocar no código)
# Linux/Mac:  export ANTHROPIC_API_KEY="sk-ant-..."
# Windows:    $env:ANTHROPIC_API_KEY = "sk-ant-..."
CHAVE_API = os.environ.get("ANTHROPIC_API_KEY", "COLOQUE_SUA_CHAVE_AQUI")

PASTA_ORIGEM  = "dados_ampl"
PASTA_DESTINO = "modelos_jump"
MODELO        = "claude-sonnet-4-5"  # mais capaz para conversão de código
PAUSA_SEGUNDOS = 3                       # pausa entre chamadas à API

# ─────────────────────────────────────────────────────────────────────────────
# Cliente Anthropic
# ─────────────────────────────────────────────────────────────────────────────

cliente = anthropic.Anthropic(api_key=CHAVE_API)

# ─────────────────────────────────────────────────────────────────────────────
# Função de conversão
# ─────────────────────────────────────────────────────────────────────────────

def traduzir_para_jump(conteudo: str, nome_arquivo: str) -> str | None:
    """
    Envia o conteúdo do arquivo para o Claude e retorna o código JuMP gerado.
    Retorna None em caso de erro.
    """
    extensao = Path(nome_arquivo).suffix.lower()
    formato  = "AMPL (.mod)" if extensao == ".mod" else "GAMS (.gms)"

    prompt = f"""Você é um especialista em otimização matemática.
Vou te passar o conteúdo de um arquivo no formato {formato}.
Preciso que você converta esse modelo exato para a sintaxe do Julia usando o pacote JuMP.

Regras estritas:
1. Retorne APENAS o código em Julia, sem explicações, sem formatação markdown (sem ```julia).
2. O código deve ser executável e autocontido.
3. Inclua todos os `using` necessários no topo (JuMP, Ipopt, etc).
4. Crie a modelagem completa: variáveis, função objetivo e restrições.
5. Use Ipopt como solver padrão (será trocado dinamicamente pelo runner).
6. Ao final, adicione estas três linhas exatas para captura de resultados:
   optimize!(model)
   println("Status: ", termination_status(model))
   println("Objetivo: ", objective_value(model))

Aqui está o modelo {nome_arquivo}:

{conteudo}"""

    try:
        resposta = cliente.messages.create(
            model=MODELO,
            max_tokens=4096,
            messages=[
                {"role": "user", "content": prompt}
            ]
        )

        codigo = resposta.content[0].text.strip()

        # Remove blocos markdown se o modelo os incluir mesmo assim
        if codigo.startswith("```"):
            linhas = codigo.split("\n")
            codigo = "\n".join(linhas[1:-1] if linhas[-1] == "```" else linhas[1:])

        return codigo

    except anthropic.AuthenticationError:
        print("\n❌ Chave da API inválida. Verifique ANTHROPIC_API_KEY.")
        raise
    except anthropic.RateLimitError:
        print("\n⚠️  Rate limit atingido. Aguardando 60 segundos...")
        time.sleep(60)
        return None  # tenta novamente
    except Exception as e:
        print(f"\n❌ Erro na API para {nome_arquivo}: {e}")
        return None


# ─────────────────────────────────────────────────────────────────────────────
# Conversão em lote
# ─────────────────────────────────────────────────────────────────────────────

def iniciar_traducao(pasta_origem: str, pasta_destino: str, arquivo_unico: str = None):
    """
    Converte todos os arquivos .mod e .gms de pasta_origem para pasta_destino.
    Se arquivo_unico for passado, converte apenas ele.
    """
    origem  = Path(pasta_origem)
    destino = Path(pasta_destino)
    destino.mkdir(parents=True, exist_ok=True)

    # Monta lista de arquivos a converter
    if arquivo_unico:
        arquivos = [Path(arquivo_unico)]
        if not arquivos[0].exists():
            # Tenta dentro da pasta de origem
            arquivos = [origem / arquivo_unico]
    else:
        arquivos = sorted(
            [f for f in origem.iterdir() if f.suffix.lower() in (".mod", ".gms")]
        )

    if not arquivos:
        print(f"⚠️  Nenhum arquivo .mod ou .gms encontrado em: {origem}")
        return

    # Contadores
    total     = len(arquivos)
    sucesso   = 0
    pulados   = 0
    falhas    = 0

    print(f"🔄 Iniciando a tradução de {total} arquivo(s)...\n")
    print(f"   Origem  : {origem.resolve()}")
    print(f"   Destino : {destino.resolve()}")
    print(f"   Modelo  : {MODELO}\n")
    print("─" * 55)

    for i, arquivo in enumerate(arquivos, 1):
        nome_base     = arquivo.stem
        caminho_dest  = destino / f"{nome_base}.jl"

        prefixo = f"[{i:3d}/{total}] {arquivo.name}"

        # Pula se já foi traduzido (retoma de onde parou)
        if caminho_dest.exists():
            print(f"⏩ {prefixo} — já traduzido, pulando.")
            pulados += 1
            continue

        print(f"⚙️  {prefixo} ...", end=" ", flush=True)

        # Lê o arquivo fonte
        try:
            conteudo = arquivo.read_text(encoding="utf-8", errors="ignore")
        except Exception as e:
            print(f"❌ Erro ao ler arquivo: {e}")
            falhas += 1
            continue

        # Chama a API
        codigo_julia = traduzir_para_jump(conteudo, arquivo.name)

        if codigo_julia:
            # Adiciona cabeçalho informativo
            cabecalho = (
                f"# Gerado automaticamente por converter_ampl.py\n"
                f"# Origem : {arquivo.name}\n"
                f"# Modelo : {MODELO}\n\n"
            )
            caminho_dest.write_text(cabecalho + codigo_julia + "\n", encoding="utf-8")
            print("✅ Sucesso!")
            sucesso += 1
        else:
            print("❌ Falha.")
            falhas += 1

        # Pausa para não sobrecarregar a API
        if i < total:
            time.sleep(PAUSA_SEGUNDOS)

    # Resumo final
    print("\n" + "─" * 55)
    print(f"  ✅ Convertidos : {sucesso}")
    print(f"  ⏩ Pulados     : {pulados}")
    print(f"  ❌ Falhas      : {falhas}")
    print(f"  📁 Destino     : {destino.resolve()}")
    print("─" * 55)


# ─────────────────────────────────────────────────────────────────────────────
# CLI
# ─────────────────────────────────────────────────────────────────────────────

def parse_args():
    p = argparse.ArgumentParser(
        description="Converte arquivos AMPL/GAMS para JuMP (Julia) via API Anthropic.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemplos:
  python converter_ampl.py
  python converter_ampl.py --origem problems/ampl --destino converted
  python converter_ampl.py --arquivo problems/ampl/hs001.mod
        """
    )
    p.add_argument("--origem",   default=PASTA_ORIGEM,  help=f"Pasta de origem (padrão: {PASTA_ORIGEM})")
    p.add_argument("--destino",  default=PASTA_DESTINO, help=f"Pasta de destino (padrão: {PASTA_DESTINO})")
    p.add_argument("--arquivo",  default=None,           help="Converter apenas um arquivo específico")
    return p.parse_args()


if __name__ == "__main__":
    if CHAVE_API == "SUA_CHAVE_AQUI":
        print("⚠️  Configure a variável de ambiente ANTHROPIC_API_KEY antes de rodar.")
        print("   Linux/Mac : export ANTHROPIC_API_KEY='sk-ant-...'")
        print("   Windows   : $env:ANTHROPIC_API_KEY = 'sk-ant-...'")
        exit(1)

    args = parse_args()
    iniciar_traducao(args.origem, args.destino, args.arquivo)
