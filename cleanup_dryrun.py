#!/usr/bin/env python3
"""
cleanup_dryrun.py
─────────────────────────────────────────────────────────────────────────────
Faxina técnica segura do projeto de benchmark NLP.

MODO PADRÃO (DRY-RUN):  Apenas lista o que SERIA removido/movido.
MODO REAL:               python cleanup_dryrun.py --execute

Regras:
  - Nunca apaga sem confirmação explícita
  - Arquivos acadêmicos e reprodutíveis são preservados (MANTER)
  - .venv pode ser removido pois é regenerável
  - resultados_coconut.csv é consolidado, não removido
  - converter.py (vazio) é candidato seguro à remoção

Uso:
  python cleanup_dryrun.py              # dry-run (padrão)
  python cleanup_dryrun.py --execute    # execução real com confirmação
  python cleanup_dryrun.py --json       # saída estruturada JSON
─────────────────────────────────────────────────────────────────────────────
"""

import argparse
import json
import shutil
import sys
from datetime import datetime
from pathlib import Path

# ── Raiz do projeto (pasta pai deste script) ─────────────────────────────────
RAIZ = Path(__file__).parent.resolve()
LOG_FILE = RAIZ / f"cleanup_log_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt"

# ── Definição de candidatos ──────────────────────────────────────────────────
#
# Cada item é um dict com:
#   path        : Path relativa à RAIZ
#   tipo        : "dir" | "file"
#   acao        : "REMOVER" | "REVISAR" | "MANTER" | "CONSOLIDAR"
#   motivo      : Justificativa técnica
#   risco       : "NENHUM" | "BAIXO" | "MEDIO" | "ALTO"
#   regeneravel : True se pode ser recriado facilmente
# ─────────────────────────────────────────────────────────────────────────────

CANDIDATOS = [
    {
        "path": ".venv",
        "tipo": "dir",
        "acao": "REMOVER",
        "motivo": (
            "Ambiente Python virtual com >1600 arquivos. "
            "100% regenerável com: python -m venv .venv && pip install anthropic requests beautifulsoup4"
        ),
        "risco": "NENHUM",
        "regeneravel": True,
    },
    {
        "path": "scripts_automacao/converter.py",
        "tipo": "file",
        "acao": "REMOVER",
        "motivo": "Arquivo vazio (0 bytes). Nunca foi implementado.",
        "risco": "NENHUM",
        "regeneravel": False,
    },
    {
        "path": "scripts_automacao/02_batch_runner.jl",
        "tipo": "file",
        "acao": "REVISAR",
        "motivo": (
            "Superado funcionalmente por executar_coconut.jl. "
            "ATENÇÃO: usa NLopt.LD_LBFGS em vez de LD_SLSQP — verificar se há lógica única antes de remover."
        ),
        "risco": "BAIXO",
        "regeneravel": False,
    },
    {
        "path": "modelos_jump_erros",
        "tipo": "dir",
        "acao": "MANTER",
        "motivo": "Contém NARX_CFy.jl com erro de conversão. Pendente revisão manual ou correção.",
        "risco": "MEDIO",
        "regeneravel": False,
    },
    {
        "path": "prompts_claude",
        "tipo": "dir",
        "acao": "REVISAR",
        "motivo": (
            "24 arquivos de prompt históricos usados na conversão via API. "
            "Conversão já concluída. Preservar para rastreabilidade/reprodutibilidade."
        ),
        "risco": "BAIXO",
        "regeneravel": False,
    },
    {
        "path": "respostas_claude",
        "tipo": "dir",
        "acao": "REVISAR",
        "motivo": (
            "22 arquivos de resposta bruta da API. Modelos já extraídos para modelos_jump_gams/. "
            "Funcionam como 'log' da conversão — valor arqueológico para auditoria."
        ),
        "risco": "MEDIO",
        "regeneravel": False,
    },
    {
        "path": "resultados/resultados_coconut.csv",
        "tipo": "file",
        "acao": "CONSOLIDAR",
        "motivo": (
            "Contém 723 linhas com dados duplicados de 2 execuções diferentes: "
            "linhas antigas com aspas (executar_coconut_robusto.jl) e novas sem aspas "
            "(executar_coconut.jl). Deve ser consolidado, não removido."
        ),
        "risco": "ALTO",
        "regeneravel": False,
    },
    {
        "path": "convert_ampl_to_jump.py",
        "tipo": "file",
        "acao": "REVISAR",
        "motivo": (
            "Arquivo na raiz do projeto — localização incorreta. "
            "Possível duplicata de scripts_automacao/converter_ampl_jump.py. "
            "Comparar conteúdo antes de mover para scripts_automacao/ ou remover."
        ),
        "risco": "BAIXO",
        "regeneravel": False,
    },
]

# ── Funções de utilidade ──────────────────────────────────────────────────────

def tamanho_humano(path: Path) -> str:
    """Retorna tamanho formatado de arquivo ou diretório."""
    try:
        if path.is_file():
            b = path.stat().st_size
        else:
            b = sum(f.stat().st_size for f in path.rglob("*") if f.is_file())
        for unit in ["B", "KB", "MB", "GB"]:
            if b < 1024:
                return f"{b:.1f} {unit}"
            b /= 1024
        return f"{b:.1f} TB"
    except Exception:
        return "?"


def contar_arquivos(path: Path) -> int:
    """Conta arquivos em um diretório recursivamente."""
    try:
        return sum(1 for _ in path.rglob("*") if _.is_file())
    except Exception:
        return 0


def log(msg: str, file_handle=None):
    """Imprime e registra em arquivo de log."""
    print(msg)
    if file_handle:
        file_handle.write(msg + "\n")


# ── Análise e relatório ───────────────────────────────────────────────────────

def analisar(candidatos, raiz: Path, log_fh=None):
    """Analisa os candidatos e retorna lista com informações detalhadas."""
    resultados = []
    for c in candidatos:
        path_abs = raiz / c["path"]
        existe = path_abs.exists()
        info = {
            **c,
            "path_abs": str(path_abs),
            "existe": existe,
            "tamanho": tamanho_humano(path_abs) if existe else "N/A",
            "n_arquivos": contar_arquivos(path_abs) if (existe and path_abs.is_dir()) else (1 if existe else 0),
        }
        resultados.append(info)
    return resultados


def imprimir_relatorio(resultados, log_fh=None):
    """Imprime relatório detalhado no terminal e arquivo de log."""
    linha = "─" * 80
    titulo = "RELATÓRIO DE FAXINA TÉCNICA — BENCHMARK NLP"
    log(f"\n{'═' * 80}", log_fh)
    log(f"  {titulo}", log_fh)
    log(f"  Gerado em: {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}", log_fh)
    log(f"  Raiz: {RAIZ}", log_fh)
    log(f"{'═' * 80}\n", log_fh)

    acoes_count = {}
    total_liberavel = 0

    for r in resultados:
        acao = r["acao"]
        acoes_count[acao] = acoes_count.get(acao, 0) + 1

        # Ícone por ação
        icone = {
            "REMOVER":     "🗑️  [SEGURO REMOVER]",
            "REVISAR":     "🔍 [REVISAR MANUALMENTE]",
            "MANTER":      "✅ [MANTER]",
            "CONSOLIDAR":  "🔧 [CONSOLIDAR/REPARAR]",
        }.get(acao, "❓")

        status = "✅ EXISTE" if r["existe"] else "⚠️  NÃO ENCONTRADO"

        log(linha, log_fh)
        log(f"{icone}", log_fh)
        log(f"  Caminho    : {r['path']}", log_fh)
        log(f"  Tipo       : {'Diretório' if r['tipo'] == 'dir' else 'Arquivo'}", log_fh)
        log(f"  Status     : {status}", log_fh)
        log(f"  Tamanho    : {r['tamanho']} ({r['n_arquivos']} arquivos)", log_fh)
        log(f"  Risco      : {r['risco']}", log_fh)
        log(f"  Regenerável: {'Sim' if r['regeneravel'] else 'Não'}", log_fh)
        log(f"  Motivo     : {r['motivo']}", log_fh)

        if acao == "REMOVER" and r["existe"] and r["risco"] == "NENHUM":
            log(f"  ✔ Candidato a remoção sem risco.", log_fh)
            if r["tipo"] == "dir":
                b = sum(f.stat().st_size for f in (RAIZ / r["path"]).rglob("*") if f.is_file())
                total_liberavel += b

    log(linha, log_fh)
    log(f"\n{'═' * 80}", log_fh)
    log("  RESUMO", log_fh)
    log(f"{'═' * 80}", log_fh)
    for acao, n in sorted(acoes_count.items()):
        log(f"  {acao:<15}: {n} item(s)", log_fh)

    if total_liberavel > 0:
        mb = total_liberavel / (1024 * 1024)
        log(f"\n  Espaço total liberável (itens REMOVER sem risco): {mb:.1f} MB", log_fh)

    log(f"\n  ⚠️  MODO DRY-RUN — Nenhum arquivo foi modificado.", log_fh)
    log(f"  Para executar a limpeza real: python cleanup_dryrun.py --execute", log_fh)
    log(f"{'═' * 80}\n", log_fh)


# ── Execução real ─────────────────────────────────────────────────────────────

def executar_limpeza(resultados, raiz: Path, log_fh=None):
    """Executa a limpeza com confirmação item a item."""
    log("\n⚠️  MODO EXECUÇÃO REAL ATIVADO\n", log_fh)
    log("  Apenas itens marcados como REMOVER com risco NENHUM serão processados.", log_fh)
    log("  Cada item requer confirmação explícita.\n", log_fh)

    candidatos_remocao = [
        r for r in resultados
        if r["acao"] == "REMOVER" and r["risco"] == "NENHUM" and r["existe"]
    ]

    if not candidatos_remocao:
        log("  Nenhum item elegível para remoção automática encontrado.", log_fh)
        return

    for r in candidatos_remocao:
        path_abs = Path(r["path_abs"])
        print(f"\n{'─' * 60}")
        print(f"  🗑️  REMOVER: {r['path']}")
        print(f"  Tamanho   : {r['tamanho']} ({r['n_arquivos']} arquivos)")
        print(f"  Motivo    : {r['motivo']}")
        resposta = input("\n  Confirmar remoção? [s/N]: ").strip().lower()

        if resposta == "s":
            try:
                if r["tipo"] == "dir":
                    shutil.rmtree(path_abs)
                    msg = f"  ✅ Diretório removido: {r['path']}"
                else:
                    path_abs.unlink()
                    msg = f"  ✅ Arquivo removido: {r['path']}"
                log(msg, log_fh)
            except Exception as e:
                log(f"  ❌ ERRO ao remover {r['path']}: {e}", log_fh)
        else:
            log(f"  ⏭️  Pulado: {r['path']}", log_fh)

    log("\n✅ Processo de limpeza concluído.", log_fh)


# ── Consolidação do resultados_coconut.csv ───────────────────────────────────

def consolidar_coconut(raiz: Path, log_fh=None):
    """
    Consolida resultados_coconut.csv removendo linhas duplicadas
    e normalizando o esquema (remove aspas extras de linhas antigas).
    """
    import csv
    import io

    arquivo = raiz / "resultados" / "resultados_coconut.csv"
    backup  = raiz / "resultados" / "resultados_coconut_BACKUP.csv"
    saida   = raiz / "resultados" / "resultados_consolidado.csv"

    if not arquivo.exists():
        log(f"  ❌ Arquivo não encontrado: {arquivo}", log_fh)
        return

    # Fazer backup
    shutil.copy2(arquivo, backup)
    log(f"  📦 Backup criado: {backup.name}", log_fh)

    linhas_raw = arquivo.read_text(encoding="utf-8").splitlines()
    log(f"  📄 Total de linhas (bruto): {len(linhas_raw)}", log_fh)

    # Normalizar: remover aspas externas de cada campo
    linhas_normalizadas = []
    header = None
    vistas = set()

    for i, linha in enumerate(linhas_raw):
        # Parsear via csv reader para lidar com aspas
        try:
            row = next(csv.reader(io.StringIO(linha)))
        except Exception:
            continue

        # Primeira linha: cabeçalho
        if i == 0:
            header = [c.strip().strip('"') for c in row]
            linhas_normalizadas.append(header)
            continue

        if len(row) < 3:
            continue

        # Normalizar campos
        row_clean = [c.strip().strip('"') for c in row]

        # Chave de deduplicação: Problema + Solver
        chave = (row_clean[0], row_clean[1]) if len(row_clean) >= 2 else tuple(row_clean)

        if chave not in vistas:
            vistas.add(chave)
            linhas_normalizadas.append(row_clean)

    log(f"  ✅ Linhas após deduplicação: {len(linhas_normalizadas) - 1}", log_fh)

    # Escrever arquivo consolidado
    with open(saida, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerows(linhas_normalizadas)

    log(f"  💾 Arquivo consolidado salvo: {saida.name}", log_fh)
    log(f"  ⚠️  Original preservado como backup: {backup.name}", log_fh)


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="Faxina técnica segura do projeto benchmark NLP.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__
    )
    parser.add_argument("--execute",     action="store_true", help="Executa limpeza real (com confirmação)")
    parser.add_argument("--consolidar",  action="store_true", help="Consolida resultados_coconut.csv")
    parser.add_argument("--json",        action="store_true", help="Saída em formato JSON")
    parser.add_argument("--sem-log",     action="store_true", help="Não salva arquivo de log")
    args = parser.parse_args()

    log_fh = None if args.sem_log else open(LOG_FILE, "w", encoding="utf-8")

    try:
        resultados = analisar(CANDIDATOS, RAIZ, log_fh)

        if args.json:
            print(json.dumps(
                [{k: v for k, v in r.items() if k != "path_abs"} for r in resultados],
                indent=2, ensure_ascii=False
            ))
            return

        imprimir_relatorio(resultados, log_fh)

        if args.consolidar:
            log("\n🔧 CONSOLIDANDO resultados_coconut.csv...", log_fh)
            consolidar_coconut(RAIZ, log_fh)

        if args.execute:
            executar_limpeza(resultados, RAIZ, log_fh)
        else:
            print(f"\n💡 Log salvo em: {LOG_FILE.name}" if not args.sem_log else "")

    finally:
        if log_fh:
            log_fh.close()


if __name__ == "__main__":
    main()
