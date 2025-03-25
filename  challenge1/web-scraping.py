import requests
from bs4 import BeautifulSoup
import wget
import os
import zipfile

url = 'https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos'

response = requests.get(url)
soup = BeautifulSoup(response.content, 'html.parser')

anexos = soup.find_all('a', class_='internal-link')

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