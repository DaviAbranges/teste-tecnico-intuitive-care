import requests
from bs4 import BeautifulSoup
import wget
import os
import zipfile
# URL da página que contém os anexos
url = 'https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos'

# Fazendo a requisição para obter o conteúdo da página
response = requests.get(url)
soup = BeautifulSoup(response.content, 'html.parser')

# Buscando os links dentro da página que contém "Anexo I" e "Anexo II"
anexos = soup.find_all('a', class_='internal-link')

# Filtrando os links de acordo com os textos ou partes do href
for anexo in anexos:
    if 'Anexo_II' in anexo['href'] and anexo['href'].endswith('.pdf'):
        wget.download(anexo['href'], 'Anexo_II.pdf')
    elif 'Anexo_I' in anexo['href'] and anexo['href'].endswith('.pdf'):
        wget.download(anexo['href'], 'Anexo_I.pdf')

with zipfile.ZipFile('Anexos.zip', 'w') as zipf:
    zipf.write('Anexo_I.pdf')
    zipf.write('Anexo_II.pdf')
    os.remove('Anexo_I.pdf')
    os.remove('Anexo_II.pdf')