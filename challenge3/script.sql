CREATE TABLE operadoras_ativas (
    Registro_ANS INT PRIMARY KEY,
    cnpj VARCHAR(18),
    Razao_Social VARCHAR(255),
    Nome_fantasia VARCHAR(255),
    Modalidade VARCHAR(100),
    Logradouro VARCHAR(255),
    Numero VARCHAR(10),
    Complemento VARCHAR(255),
    Bairro VARCHAR(255),
    Cidade VARCHAR(255),
    uf VARCHAR(2),
    Cep VARCHAR(8),
    DDD VARCHAR(2),
    telefone VARCHAR(9),
    Fax VARCHAR(9),
    Endereco_eletronico VARCHAR(255),
    Representante VARCHAR(255),
    Cargo_representante VARCHAR(255),
    Regiao_da_Comercializacao VARCHAR(255),
    Data_de_Registro DATE,
    data_registro DATE
);

CREATE TABLE demonstracoes_contabeis (
    Data  VARCHAR(255),
    REG_ANS INT,
    CD_CONTA_CONTABIL INT,
    DESCRICAO VARCHAR(255),
    VL_SALDO_INICIAL DECIMAL(10,2),
    VL_SALDO_FINAL DECIMAL(10,2)
);

LOAD DATA LOCAL INFILE '/home/davi/testes-tecnicos/intuitiveCare/Relatorio_cadop.csv'
INTO TABLE operadoras_ativas
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Registro_ANS, cnpj, Razao_Social, Nome_fantasia, Modalidade, Logradouro, Numero, Complemento, Bairro, Cidade, uf, Cep, DDD, telefone, Fax, Endereco_eletronico, Representante, Cargo_representante, Regiao_da_Comercializacao, Data_de_Registro, data_registro);

LOAD DATA LOCAL INFILE '/home/davi/testes-tecnicos/intuitiveCare/4T2023.csv'
INTO TABLE demonstracoes_contabeis
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Data, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, VL_SALDO_INICIAL, VL_SALDO_FINAL)

LOAD DATA LOCAL INFILE '/home/davi/testes-tecnicos/intuitiveCare/4T2024.csv'
INTO TABLE demonstracoes_contabeis
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Data, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, VL_SALDO_INICIAL, VL_SALDO_FINAL)
SET Data = IF(STR_TO_DATE(Data, '%Y-%m-%d') IS NOT NULL, 
              DATE_FORMAT(STR_TO_DATE(Data, '%Y-%m-%d'), '%d/%m/%Y'), 
              Data);

SELECT `Registro_ANS`,`Nome_fantasia`, `DESCRICAO`, `VL_SALDO_INICIAL`, `VL_SALDO_FINAL`  FROM operadoras_ativas o
JOIN demonstracoes_contabeis d ON d.REG_ANS = o.Registro_ANS
WHERE d.DESCRICAO LIKE '%EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR%'
    AND QUARTER(STR_TO_DATE(d.Data, '%d/%m/%Y')) = 4 AND YEAR(STR_TO_DATE(d.Data, '%d/%m/%Y')) = YEAR(CURDATE()) - 1 AND QUARTER(CURDATE()) = 1
ORDER BY d.VL_SALDO_FINAL DESC
LIMIT 10;


SELECT 
    o.Razao_Social,
    SUM(d.VL_SALDO_FINAL) AS Total_Despesa
FROM operadoras_ativas o
JOIN demonstracoes_contabeis d 
    ON d.REG_ANS = o.Registro_ANS
WHERE d.DESCRICAO LIKE '%EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR%'
  AND YEAR(STR_TO_DATE(d.Data, '%d/%m/%Y')) = YEAR(CURDATE()) - 1
GROUP BY o.Registro_ANS, o.Razao_Social
ORDER BY Total_Despesa DESC
LIMIT 10;
