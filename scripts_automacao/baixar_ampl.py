import os
import time
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin

# configuração inicial
url = 'https://plato.asu.edu/ftp/ampl-nlp-source/'
pasta_destino = 'dados_ampl'
HEADERS = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0 Safari/537.36'}

def baixar_arquivo():
    print(f"acessando {url}...")
    session = requests.Session()
    session.headers.update(HEADERS)
    try:
        response = session.get(url, timeout=15)
    except Exception as e:
        print(f"Erro ao conectar: {e}")
        return

    if response.status_code != 200:
        print(f"Erro ao acessar a página: {response.status_code}")
        return

    soup = BeautifulSoup(response.text, 'html.parser')
    links = soup.find_all('a')

    # filtrar os links que contem href e terminam com a extensao .mod
    arquivos_mod = [link.get('href') for link in links if link.get('href') and link.get('href').lower().endswith('.mod')]

    print(f"encontrados {len(arquivos_mod)} arquivos '.mod'. Iniciando o download...\n")

    # garantir que a pasta de destino exista
    os.makedirs(pasta_destino, exist_ok=True)

    for arquivo in arquivos_mod:
        arquivo_url = urljoin(url, arquivo)
        nome_arquivo = arquivo.split('/')[-1]
        caminho_destino = os.path.join(pasta_destino, nome_arquivo)

        # realizar o download do arquivo
        try:
            print(f"baixando {nome_arquivo}...", end="")
            req_arquivo = session.get(arquivo_url, timeout=15)
            if req_arquivo.status_code != 200:
                print(f"erro HTTP {req_arquivo.status_code}")
                continue

            with open(caminho_destino, 'wb') as f:
                f.write(req_arquivo.content)
            print("feito.")

            time.sleep(1)  # evitar sobrecarregar o servidor
        except Exception as e:
            print(f"erro ao baixar {nome_arquivo}: {e}")
    print("download concluído.")


if __name__ == "__main__":
    baixar_arquivo()