import os
import io
import time
import requests
import pandas as pd

# ── Configurações ──────────────────────────────────────────────────────────────
URL_TABELA      = "https://arnold-neumaier.at/glopt/coconut/Benchmark/Library1_new_v1.html"
URL_GITHUB_RAW  = "https://raw.githubusercontent.com/GAMS-dev/gamsworld/master/GlobalLib/scalar_models/"
PASTA_DESTINO   = "dados_gams"
ARQUIVO_GABARITO = "gabarito_solucoes.csv"
PAUSA_SEGUNDOS  = 0.3
MAX_RETRIES     = 3
# ──────────────────────────────────────────────────────────────────────────────

HEADERS = {
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36"
}

def buscar_html(url: str) -> str:
    resp = requests.get(url, headers=HEADERS, timeout=30)
    resp.raise_for_status()
    return resp.text

def extrair_tabela_corrigida() -> pd.DataFrame:
    print(f"📄 Lendo tabela de benchmark em:\n   {URL_TABELA}\n")
    html = buscar_html(URL_TABELA)
    
    tabelas = pd.read_html(io.StringIO(html))
    df = tabelas[0]
    
    # Remove as linhas que são apenas repetições do cabeçalho
    df = df[df.iloc[:, 0].astype(str).str.lower() != 'number'].copy()
    
    # A tabela de Neumaier é rígida:
    # Coluna 1: Nome do Problema (ex: abel, alkyl)
    # Coluna 8: Fbest (ex: 225.19460000 ou (0.00000000))
    df_limpo = df.iloc[:, [1, 8]].copy()
    df_limpo.columns = ["Model", "Best_Solution"]
    
    df_limpo["Model"] = df_limpo["Model"].astype(str).str.strip()
    df_limpo["Best_Solution"] = df_limpo["Best_Solution"].astype(str).str.strip()
    
    return df_limpo

def filtrar_viaveis_reais(df: pd.DataFrame) -> pd.DataFrame:
    """
    Remove problemas sem Fbest conhecido ou que sejam inviáveis (marcados com parênteses).
    """
    # Remove strings vazias ou nulas
    df = df[~df["Best_Solution"].str.lower().isin(["nan", "none", "", "na"])].copy()
    
    # Remove problemas inviáveis (que contêm parênteses)
    df_filtrado = df[~df["Best_Solution"].str.contains(r'\(|\)', regex=True)].copy()
    
    print(f"🎯 Filtro Real aplicado: {len(df_filtrado)} problemas viáveis encontrados!\n")
    return df_filtrado

def baixar_arquivo(nome_modelo: str) -> bool:
    nome_arquivo = f"{nome_modelo}.gms"
    url = f"{URL_GITHUB_RAW}{nome_arquivo}"
    destino = os.path.join(PASTA_DESTINO, nome_arquivo)

    for tentativa in range(1, MAX_RETRIES + 1):
        try:
            resp = requests.get(url, headers=HEADERS, timeout=20)
            if resp.status_code == 200:
                with open(destino, "wb") as f:
                    f.write(resp.content)
                return True
            elif resp.status_code == 404:
                return False # Arquivo não existe no GitHub
        except requests.RequestException:
            time.sleep(1.0)
            
    return False

def executar_pipeline():
    os.makedirs(PASTA_DESTINO, exist_ok=True)
    
    try:
        df_completo = extrair_tabela_corrigida()
        df_viaveis = filtrar_viaveis_reais(df_completo)
        
        # Salva o gabarito
        df_viaveis.to_csv(ARQUIVO_GABARITO, index=False)
        print(f"📊 Gabarito salvo em '{ARQUIVO_GABARITO}'.\n")
        
        total = len(df_viaveis)
        ok_count = 0
        fail_count = 0
        nao_found = []

        print(f"🌐 Iniciando download de {total} arquivos .gms...\n")

        for i, (_, linha) in enumerate(df_viaveis.iterrows(), start=1):
            nome = linha["Model"]
            print(f"[{i:>3}/{total}] ⬇️  {nome}.gms ... ", end="", flush=True)

            sucesso = baixar_arquivo(nome)

            if sucesso:
                print("✅ OK")
                ok_count += 1
            else:
                print("❌ Não encontrado")
                fail_count += 1
                nao_found.append(nome)

            time.sleep(PAUSA_SEGUNDOS)

        print(f"\n✅ Total Baixados: {ok_count} | ❌ Falhas: {fail_count}")
        
    except Exception as e:
        print(f"\n❌ Erro fatal: {e}")

if __name__ == "__main__":
    executar_pipeline()