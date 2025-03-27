import requests
from bs4 import BeautifulSoup
import wget
import os
import zipfile
import tabula
import pandas as pd 
url = 'https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos'

response = requests.get(url)
soup = BeautifulSoup(response.content, 'html.parser')

find_attachment = soup.find('a', class_='internal-link')

attachment = wget.download(find_attachment['href'], 'attachment.pdf')
if os.path.exists('attachment.pdf'):
    print("PDF baixado com sucesso.")
else:
    print("Falha no download do PDF.")

tables = tabula.read_pdf(attachment, pages="3-180", multiple_tables=True)

if len(tables) > 0:
    df_combined = pd.concat(tables, ignore_index=True)
    df_combined.dropna(how='all', inplace=True)
    df_combined.replace({'OD': 'Odontológica', 'AMB': 'Ambulatorial'}, inplace=True)
csv_file = 'Rol_de_Procedimentos.csv'
df_combined.to_csv(csv_file, index=False)

zip_filename = f"Teste_DaviAbranges.zip"
with zipfile.ZipFile(zip_filename, 'w') as zipf:
    zipf.write(csv_file)

os.remove(attachment)
os.remove(csv_file)
print(f"Arquivo {zip_filename} criado com sucesso!")