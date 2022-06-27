-- Heitor Lorenção Busato - 2015207975

-- Questão 01 -- 

CREATE TABLE Cidade
(
	CodCidade	INTEGER NOT NULL,	
	Nome		VARCHAR(100) NOT NULL,
	UF		CHAR(2),
	CONSTRAINT pkCidade PRIMARY KEY (CodCidade)
);

CREATE TABLE Cliente
(
	CodCliente	INTEGER NOT NULL,	
	Nome		VARCHAR(100) NOT NULL,
	Email		VARCHAR(250),
	CodCidade	INTEGER NOT NULL,
	CONSTRAINT pkCliente PRIMARY KEY (CodCliente),
	CONSTRAINT fkClienteCidade FOREIGN KEY (CodCidade) REFERENCES Cidade(CodCidade)
);

CREATE TABLE Fornecedor
(
	CodFornecedor	INTEGER NOT NULL,	
	Nome		VARCHAR(100) NOT NULL,
	Email		VARCHAR(250),
	CodCidade	INTEGER NOT NULL,
	CONSTRAINT pkFornecedor PRIMARY KEY (CodFornecedor),
	CONSTRAINT fkFornecedorCidade FOREIGN KEY (CodCidade) REFERENCES Cidade(CodCidade)
);

CREATE TABLE Produto
(
	CodProduto	INTEGER NOT NULL,	
	Descricao	VARCHAR(100) NOT NULL,
	Estoque		DOUBLE DEFAULT 0 NOT NULL,
	CONSTRAINT pkProduto PRIMARY KEY (CodProduto)
);

CREATE TABLE Pedido	
(
	CodPedido	INTEGER NOT NULL,
	CodCliente	INTEGER NOT NULL,
	Data		DATE,
	ValorTotal	DOUBLE DEFAULT 0 NOT NULL,
	CONSTRAINT pkPedido PRIMARY KEY (CodPedido),
	CONSTRAINT fkPedidoCliente FOREIGN KEY (CodCliente) REFERENCES Cliente(CodCliente)
);

CREATE TABLE Requisicao
(
	CodRequisicao	INTEGER NOT NULL,
	CodFornecedor	INTEGER NOT NULL,
	Data		DATE,
	ValorTotal	DOUBLE DEFAULT 0 NOT NULL,
	CONSTRAINT pkRequisicao PRIMARY KEY (CodRequisicao),
	CONSTRAINT fkRequisicaoFornecedor FOREIGN KEY (CodFornecedor) REFERENCES Fornecedor(CodFornecedor)
);

CREATE TABLE ItemPedido
(
	CodPedido	INTEGER NOT NULL,
	CodProduto	INTEGER NOT NULL,
	Quantidade	DOUBLE DEFAULT 0 NOT NULL,
	ValorUnitario	DOUBLE DEFAULT 0 NOT NULL,
	CONSTRAINT pkItemPedido PRIMARY KEY (CodPedido, CodProduto),
	CONSTRAINT fkItemPedidoPedido 	FOREIGN KEY (CodPedido) REFERENCES Pedido(CodPedido),
	CONSTRAINT fkItemPedidoProduto	FOREIGN KEY (CodProduto) REFERENCES Produto(CodProduto)
);

CREATE TABLE ItemRequisicao
(
	CodRequisicao	INTEGER NOT NULL,
	CodProduto	INTEGER NOT NULL,
	Quantidade	DOUBLE DEFAULT 0 NOT NULL,
	ValorUnitario	DOUBLE DEFAULT 0 NOT NULL,
	CONSTRAINT pkItemRequisicao PRIMARY KEY (CodRequisicao, CodProduto),
	CONSTRAINT fkItemRequisicaoRequisicao 	FOREIGN KEY (CodRequisicao) REFERENCES Requisicao(CodRequisicao),
	CONSTRAINT fkItemRequisicaoProduto	FOREIGN KEY (CodProduto) REFERENCES Produto(CodProduto)
);

CREATE TABLE Historico
(
	Documento	INTEGER NOT NULL,
	CodProduto	INTEGER NOT NULL,
	Movimento	CHAR(1) NOT NULL,
	Data		DATE,
	Quantidade	DOUBLE,
	Saldo		DOUBLE,
	CONSTRAINT pkHistorico PRIMARY KEY (Documento, CodProduto, Movimento),
	CONSTRAINT fkHistoricoProduto	FOREIGN KEY (CodProduto) REFERENCES Produto(CodProduto)
);

-- Questão 02 --

ALTER TABLE Pedido
add numParcela INTEGER;

-- Questão 03 -- 

CREATE TABLE Pagamento
(
	CodPedido INTEGER NOT NULL,
	NumParcela INTEGER NOT NULL,
	DataPagamento DATE,
	DataVencimento DATE,
	ValorTotal DOUBLE,
	ValorPago DOUBLE,
	Desconto DOUBLE,
	Acrescimo DOUBLE
	CONSTRAINT pkPagamento PRIMARY KEY (CodPedido, NumParcela),
	CONSTRAINT fkPagamentoPedido FOREIGN KEY(CodPedido) REFERENCES Pedido(CodPedido)
);


INSERT INTO Pagamento(CodPedido, NumParcela,DataPagamento,DataVencimento,ValorTotal,ValorPago, Desconto, Acrescimo)
VALUES (1, 3, "2017-06-13", "2017-06-13", 50.13, 45.18, 0.15*50.13, 0);

INSERT INTO Pagamento(CodPedido, NumParcela,DataPagamento,DataVencimento,ValorTotal,ValorPago, Desconto, Acrescimo)
VALUES (3, 5, "1999-06-13", "1999-06-13", 0.00, 45.18, 0.15*50.13, 0);

INSERT INTO Pagamento(CodPedido, NumParcela,DataPagamento,DataVencimento,ValorTotal,ValorPago, Desconto, Acrescimo)
VALUES (4, 5, "1998-06-13", "1998-06-13", 0.00, 45.18, 0.15*50.13, 0);

INSERT INTO Pagamento(CodPedido, NumParcela,DataPagamento,DataVencimento,ValorTotal,ValorPago, Desconto, Acrescimo)
VALUES (5, 5, "1999-06-13", "1999-06-13", 1.00, 45.18, 0.15*50.13, 0);


-- Questão 04 -- 
ALTER TABLE Cliente
DROP FOREIGN KEY fkClienteCidade,
DROP codCidade;

-- Questão 05 --	
ALTER TABLE Fornecedor
DROP FOREIGN KEY fkFornecedorCidade,
DROP codCidade;

--- Questão 06 --
ALTER TABLE Cliente
ADD codCidade INTEGER NOT NULL,
ADD CONSTRAINT fkClienteCidade FOREIGN KEY (CodCidade) REFERENCES Cidade(CodCidade);

-- Questão 07 --
ALTER TABLE Fornecedor
ADD codCidade INTEGER NOT NULL,
ADD CONSTRAINT fkFornecedorCidade FOREIGN KEY (CodCidade) REFERENCES Cidade(CodCidade);

-- Questão 08 --
-- Cidades:
INSERT INTO Cidade (CodCidade, Nome, UF)
 VALUES (1, 'Sooretama', 'ES');
 
INSERT INTO Cidade (CodCidade, Nome, UF) 
VALUES (2, 'Vitoria', 'ES');

INSERT INTO Cidade (CodCidade, Nome, UF) 
VALUES (3, 'Niteroi', 'RJ');

INSERT INTO Cidade (CodCidade, Nome, UF)
 VALUES (4, 'São Paulo', 'SP');
 
 INSERT INTO Cidade (CodCidade, Nome, UF)
 VALUES (5, 'Santos', 'SP');
 
 INSERT INTO Cidade (CodCidade, Nome, UF)
 VALUES (6, 'Guarulhos', 'SP');
 
 INSERT INTO Cidade (CodCidade, Nome, UF)
 VALUES (7, 'Montanha', 'ES');
 
 INSERT INTO Cidade (CodCidade, Nome, UF)
 VALUES (8, 'Muniz Freire', 'ES');
 
 INSERT INTO Cidade (CodCidade, Nome, UF)
 VALUES (9, 'Mimoso', 'ES');
 
-- Clientes:
INSERT INTO Cliente (CodCliente, Nome, Email, CodCidade)
 VALUES ( 1, 'Heitor', 'heitorb@outlook.com', 1);
 
INSERT INTO Cliente (CodCliente, Nome, Email, CodCidade) 
VALUES ( 2, 'Crislayne', 'crilaynedettmann@hotmail.com', 2);

INSERT INTO Cliente (CodCliente, Nome, Email, CodCidade) 
VALUES ( 3, 'Sara', 'jonacirsouza@hotmail.com', 3);

INSERT INTO Cliente (CodCliente, Nome, Email, CodCidade)
 VALUES ( 4, 'Fernando Torres', 'Fernando@outlook.com', 3);

-- Fornecedores:
INSERT INTO Fornecedor (CodFornecedor, Nome, Email, CodCidade) VALUES (1, 'Garoto', 'garoto@gmail.com', 2);
INSERT INTO Fornecedor (CodFornecedor, Nome, Email, CodCidade) VALUES (2, 'Zampirolli', 'zampirolli@gamil.com', 1);
INSERT INTO Fornecedor (CodFornecedor, Nome, Email, CodCidade) VALUES (3, 'Sadia', 'sadia@gmail.com', 3);

-- Produto:
INSERT INTO Produto (CodProduto, Descricao, Estoque) VALUES ( 1, 'Cerveja Skol', 0);
INSERT INTO Produto (CodProduto, Descricao, Estoque) VALUES ( 2, 'Refrigerante Coca-Cola', 0);
INSERT INTO Produto (CodProduto, Descricao, Estoque) VALUES ( 3, 'Refrigerante Dolly', 0);

-- Questão 09 --
ALTER TABLE Cliente
ADD novoEmail VARCHAR(100);

-- Questão 10 --
UPDATE Cliente
SET novoEmail = email;

-- Questão 11 --
ALTER TABLE Cliente
DROP email;

-- Questão 12 --
ALTER TABLE Cliente
ADD email VARCHAR(250);

-- Questão 13 --
UPDATE Cliente
SET email = novoEmail;

-- Questão 14 --
ALTER TABLE Cliente
DROP novoEmail;

-- MUDEI O CONTEUDO DO EMAIL DA CLIENTE CRISLAYNE --
UPDATE Cliente 
SET email = "crisdettmann@hotmail.com" WHERE (CodCliente = 2);

-- Questão 15 --
ALTER TABLE  Fornecedor
ADD novoEmail VARCHAR(100);

UPDATE Fornecedor
SET novoEmail = email;

ALTER TABLE Fornecedor
DROP email;

ALTER TABLE Fornecedor
ADD email VARCHAR(250);

UPDATE Fornecedor
SET email = novoEmail;

ALTER TABLE Fornecedor
DROP novoEmail;

-- Questão 16 --

DELETE FROM Cliente WHERE  Nome LIKE '%Torres%';

-- Questão 17 -- 
ALTER TABLE Produto
ADD Preco FLOAT;

-- Questão 18 --
UPDATE Produto
SET Preco = codProduto * 1.10;

-- Questão 19 -- 
DELETE FROM Cidade WHERE UF = 'SP';

-- Questão 20 -- 
ALTER TABLE Pagamento
Add stts CHAR(1) NOT NULL DEFAULT 'A' DEFAULT 'C'  DEFAULT 'P'; 

-- Questão 21 --
ALTER TABLE Historico
DROP FOREIGN KEY fkHistoricoProduto,
DROP codProduto;

-- Questão 22 --
UPDATE Historico
SET codProduto = -- Nao sei Fazer; 

ALTER TABLE Historico
ADD codProduto INTEGER NOT NULL,
ADD CONSTRAINT fkHistoricoProduto FOREIGN KEY (CodProduto) REFERENCES Produto(CodProduto);

-- Questão 23 --
UPDATE  Pagamento
SET Pagamento.stts = 'A'
WHERE (Pagamento.DataPagamento IS NULL) ;

-- Questão 24 --
UPDATE  Pagamento
SET Pagamento.stts = 'P'
WHERE (Pagamento.DataPagamento IS NOT NULL) ;
      
-- Questão 25 --
DELETE
FROM Pagamento 
WHERE YEAR(Pagamento.DataVencimento) < 2000 AND Pagamento.Stts = 'A' AND Pagamento.ValorTotal = 0;

-- Questão 26 --

UPDATE Pagamento
Set Pagamento.DataVencimento = date_add(Pagamento.DataVencimento, INTERVAL 10 DAY)
WHERE (Pagamento.ValorTotal > 600);

-- Questão 27 --

SELECT SUM(p.Desconto) As DescontoTotal
FROM Pagamento p
WHERE (p.stts = 'P');

-- Questão 28 --
SELECT SUM(p.Acrescimo) As AcrescimoTotal
FROM Pagamento p
WHERE (p.stts = 'P');

--Questão 29 --
UPDATE Produto p
SET p.estoque = 200
WHERE p.CodProduto = 2;  -- FIZ PELO CODIGO DA COCA COLA, PORÉM DA PRA FAZER PELO NOME: p.Descricao = 'Refrigerante Coca-Cola';

-- Questão 30 --

-- VALORES INSERIDOS PARA TESTE:
INSERT INTO Produto (CodProduto, Descricao, Estoque, Preco) VALUES ( 4, 'Biscoito Aymoré', 150, 4*1.1);
INSERT INTO Produto (CodProduto, Descricao, Estoque, Preco) VALUES ( 5, 'Detergente Limpol',100, 5*1.1);
INSERT INTO Produto (CodProduto, Descricao, Estoque, Preco) VALUES ( 6, 'Sabão em Pó Minuano', 95, 6*1.1);
INSERT INTO Produto (CodProduto, Descricao, Estoque, Preco) VALUES ( 7, 'Suco Tial', 230, 7*1.1);


UPDATE Produto p
SET p.Estoque = p.Estoque - 50 WHERE (p.Descricao = 'Biscoito Aymoré');

UPDATE Produto p
SET p.Estoque = p.Estoque - 25 WHERE (p.Descricao = 'Detergente Limpol');

UPDATE Produto p
SET p.Estoque = p.Estoque - 83 WHERE (p.Descricao = 'Sabão em Pó Minuano');

UPDATE Produto p
SET p.Estoque = p.Estoque - 10 WHERE (p.Descricao = 'Cerveja Skol');

UPDATE Produto p
SET p.Estoque = p.Estoque - 90 WHERE (p.Descricao = 'Suco Tiau');

-- Questão 31 --
ALTER TABLE Produto
ADD DataVencimento DATE;

-- Questão 32 --
CREATE TABLE TipoProduto
(
	CodTipoProduto INTEGER NOT NULL,
	Descricao VARCHAR(100),
	
	CONSTRAINT pkTipoProduto PRIMARY KEY (CodTipoProduto)
);

-- Questão 33 --
ALTER TABLE Produto 
ADD CodTipoProduto INTEGER NOT NULL,
ADD CONSTRAINT fkProdutoTipoProduto FOREIGN KEY (CodTipoProduto) REFERENCES TipoProduto(CodTipoProduto);

-- Questão 34 --
-- INSERINDO DATAS PARA TESTAR O EXERCICIO --
UPDATE Produto p
SET p.DataVencimento = '2017-06-25';
WHERE p.CodProduto = 4 OR CodProduto = 7;

UPDATE Produto p
SET p.Estoque = 0
WHERE (p.DataVencimento < '2017-06-26');  -- Exercicio Realizado Nesta DATA;

-- Questão 35 --
UPDATE Produto p
SET p.Estoque = 0 
WHERE (p.Estoque < 0);

-- Questão 36 --
SELECT c.nome FROM Cidade c WHERE (c.UF = 'MG');

-- Questão 37 --
SELECT c.CodCidade From Cidade c WHERE (c.nome = 'Muriaé');

-- Questão 38 --

-- INSERINDO VALORES PARA TESTES --
INSERT INTO Fornecedor (CodFornecedor, Nome, Email, CodCidade) VALUES (4, 'Nestle', 'Nestle@gmail.com', 7);
INSERT INTO Fornecedor (CodFornecedor, Nome, Email, CodCidade) VALUES (5, 'Petrobrás', 'PBR@gamil.com', 7);
INSERT INTO Fornecedor (CodFornecedor, Nome, Email, CodCidade) VALUES (6, 'Americanas', 'Americanas@Hotmail.com', 8);
INSERT INTO Fornecedor (CodFornecedor, Nome, Email, CodCidade) VALUES (7, 'Vale', 'Vale@gmail.com', 9);
INSERT INTO Fornecedor (CodFornecedor, Nome, Email, CodCidade) VALUES (8, 'Ambev', 'ambev@gov.com', 7);
INSERT INTO Fornecedor (CodFornecedor, Nome, Email, CodCidade) VALUES (9, 'Perdigao', 'perdigao@gmail.com', 8);
INSERT INTO Fornecedor (CodFornecedor, Nome, Email, CodCidade) VALUES (100, 'Sucos +', 'sucomais@gmail.com', 1);
INSERT INTO Fornecedor (CodFornecedor, Nome, Email, CodCidade) VALUES (11, 'Esquadria LTDA', 'Esquadrias@gmail.com', 2);
INSERT INTO Fornecedor (CodFornecedor, Nome, Email, CodCidade) VALUES (12, 'Distribuidora LTDA', 'Distribuidora@gmail.com', 7);
INSERT INTO Fornecedor (CodFornecedor, Nome, Email, CodCidade) VALUES (13, 'Vidros LTDA', 'Vidros@gmail.com', 5);

SELECT f.nome, f.email 
FROM fornecedor f 
WHERE (CodCidade = 7);

-- Questão 39 --

-- INSERINDO VALORES PARA TESTE --
INSERT INTO Cliente (CodCliente, Nome, Email, CodCidade)
 VALUES ( 4, 'Francisco', 'Francisco@outlook.com', 3);
 
INSERT INTO Cliente (CodCliente, Nome, Email, CodCidade)
 VALUES ( 5, 'Leonardo', 'Leonardo@outlook.com', 7);
 
INSERT INTO Cliente (CodCliente, Nome, Email, CodCidade)
 VALUES ( 6, 'Caio', 'Caio@outlook.com', 7); 
 
INSERT INTO Cliente (CodCliente, Nome, Email, CodCidade)
 VALUES ( 7, 'Douglas', 'Douglas@outlook.com', 1);
 
INSERT INTO Cliente (CodCliente, Nome, Email, CodCidade)
 VALUES ( 8, 'Antonio', 'Francisco@outlook.com', 7);
 

 SELECT c.CodCliente, c.nome
 FROM Cliente c
 WHERE (codCidade = 7);
 
 -- Questão 40 --
 -- INSERINDO VALORES EM PEDIDO PARA TESTES;
 INSERT INTO Pedido(CodPedido, CodCliente, Data, ValorTotal, numParcela) VALUES(1, 1, '2017-06-26',200, 1);
 INSERT INTO Pedido(CodPedido, CodCliente, Data, ValorTotal, numParcela) VALUES(2, 1, '2017-06-26',150, 1);
 INSERT INTO Pedido(CodPedido, CodCliente, Data, ValorTotal, numParcela) VALUES(3, 2, '2017-06-26',299, 2);
 INSERT INTO Pedido(CodPedido, CodCliente, Data, ValorTotal, numParcela) VALUES(4, 3, '2017-06-26',300, 1);
 INSERT INTO Pedido(CodPedido, CodCliente, Data, ValorTotal, numParcela) VALUES(5, 3, '2017-06-25',199, 3);
 INSERT INTO Pedido(CodPedido, CodCliente, Data, ValorTotal, numParcela) VALUES(6, 4, '2017-06-15',93, 3);
 INSERT INTO Pedido(CodPedido, CodCliente, Data, ValorTotal, numParcela) VALUES(7, 5, '2017-06-14',50, 2);
 INSERT INTO Pedido(CodPedido, CodCliente, Data, ValorTotal, numParcela) VALUES(8, 6, '2017-06-26',200, 3);
 INSERT INTO Pedido(CodPedido, CodCliente, Data, ValorTotal, numParcela) VALUES(9, 7, '2017-06-16',250, 3);
 INSERT INTO Pedido(CodPedido, CodCliente, Data, ValorTotal, numParcela) VALUES(10, 8, '2017-06-26',199, 1);
 
 SELECT p.CodPedido, p.ValorTotal
 FROM Pedido p
 WHERE (p.DATA = '2017-06-26');
 
 -- Questão 41 -- 
 SELECT p.CodProduto, p.Descricao
 FROM Produto p
		INNER JOIN Historico h
		ON p.CodProduto= h.CodProduto
 WHERE (h.Saldo = 0);
 
 -- Questão 42 -- 

 SELECT p.codProduto, p.Descricao
 FROM Produto p 
 WHERE (p.DataVencimento< '2017-06-26');
 
 -- Questão 43 --
 -- INSERINDO VALORES EM REQUISICAO PARA TESTES;
 
 INSERT INTO Requisicao(CodRequisicao, CodFornecedor, Data, ValorTotal) VALUES(1, 100, '2017-06-26', 5000);
 INSERT INTO Requisicao(CodRequisicao, CodFornecedor, Data, ValorTotal) VALUES(2, 100, '2017-06-25', 3000);
 INSERT INTO Requisicao(CodRequisicao, CodFornecedor, Data, ValorTotal) VALUES(3, 100, '2017-06-24', 4500);
 INSERT INTO Requisicao(CodRequisicao, CodFornecedor, Data, ValorTotal) VALUES(4, 4, '2017-06-23', 1200);
 INSERT INTO Requisicao(CodRequisicao, CodFornecedor, Data, ValorTotal) VALUES(5, 5, '2017-06-22', 7000); 
 INSERT INTO Requisicao(CodRequisicao, CodFornecedor, Data, ValorTotal) VALUES(6, 6, '2017-06-21', 500);
 INSERT INTO Requisicao(CodRequisicao, CodFornecedor, Data, ValorTotal) VALUES(7, 7, '2017-06-20', 2400);  
 INSERT INTO Requisicao(CodRequisicao, CodFornecedor, Data, ValorTotal) VALUES(1, 8, '2017-06-26', 1900);
 INSERT INTO Requisicao(CodRequisicao, CodFornecedor, Data, ValorTotal) VALUES(1, 1, '2017-06-26', 1400);
 INSERT INTO Requisicao(CodRequisicao, CodFornecedor, Data, ValorTotal) VALUES(1, 2, '2017-06-26', 14500);
 
 SELECT r.CodRequisicao, r.Data, r.ValorTotal
 FROM Requisicao r
 WHERE (r.CodFornecedor = 100);
 
 -- Questão 44 --
 SELECT f.email
 FROM Fornecedor f
 WHERE (f.nome LIKE '%LTDA%');

 -- Questão 45 --
  SELECT c.nome
 FROM cidade c
 WHERE (c.nome LIKE 'M%' AND c.UF = 'ES');
 
 -- Questão 46 -- 
 SELECT p.codPedido, p.ValorTotal, day(Data)
 FROM Pedido p
 WHERE (p.Data >= '2017-04-01' AND p.Data <= '2017-04-30');
 
 -- Questão 47 --
-- TESTE -- 
 INSERT INTO Cliente (CodCliente, Nome, Email, CodCidade)
 VALUES ( 9, 'Jonacir', 'Jonacir@gmail.com', 1);


 SELECT c.nome
 FROM Cliente c
 WHERE (email LIKE '%gmail.com%');
 
 -- Questão 48 -- 
--TESTE-- 
 INSERT INTO Pedido(CodPedido, CodCliente, Data, ValorTotal, numParcela) VALUES(11, 1, '2008-03-26',2000, 3);
 INSERT INTO Pedido(CodPedido, CodCliente, Data, ValorTotal, numParcela) VALUES(12, 2, '2008-03-16',2500, 3);
 INSERT INTO Pedido(CodPedido, CodCliente, Data, ValorTotal, numParcela) VALUES(13, 3, '2008-05-26',199, 1);

 SELECT p.codPedido, p.codCliente, p.ValorTotal
 FROM Pedido p
 WHERE (YEAR(Data) = 2008) AND p.ValorTotal > 1000; 
 
 -- Questão 49 --
INSERT INTO Cliente (CodCliente, Nome, Email, CodCidade)
 VALUES ( 10, 'Danilo Silva', 'Danilo@yahoo.com.br', 5);
  
INSERT INTO Cliente (CodCliente, Nome, Email, CodCidade)
 VALUES ( 11, 'Douglas Silva', 'Douglas@yahoo.com.br', 1);

 SELECT c.nome
 FROM Cliente c 
 WHERE (c.CodCidade = 1 AND c.email LIKE '%yahoo.com.br%' AND c.nome LIKE '%Silva%');
 
 -- Questão 50 --
 -- VALORES PARA TESTE -- 
INSERT INTO Produto (CodProduto, Descricao, Estoque, Preco, DataVencimento, codTipoProduto) VALUES ( 8, 'Paçoca', 230,7*1.1, '2017-07-01',1);
INSERT INTO Produto (CodProduto, Descricao, Estoque, Preco, DataVencimento, codTipoProduto) VALUES ( 9, 'Pé de Moleque', 220, 9*1.1, '2017-06-30',2);
INSERT INTO Produto (CodProduto, Descricao, Estoque, Preco, DataVencimento, codTipoProduto) VALUES ( 10, 'Goiabada', 120, 10*1.1, '2017-07-02',2);

-- OQ EU ENTENDI DA QUESTÃO : QUAIS PRODUTOS IRÃO PERDER A VALIDADE SÁBADO, A PARTIR DA DATA DE HOJE. PARA LIMITAR OS PRODUTOS JA FORA DA VALIDADE;
SELECT p.codProduto, p.Descricao, p.estoque
FROM produto p
WHERE (p.DataVencimento <= '2017-07-01') AND (p.DataVencimento >= '2017-06-27');

-- Questão 51 -- 
SELECT c.nome
FROM cidade c
WHERE (c.UF = 'RJ')
ORDER BY c.nome;

-- Questão 52 --
-- PARA TESTES--
INSERT INTO Historico(Documento, Movimento, Data, Quantidade, Saldo, codProduto) VALUES(1, 'V','2017-03-02', 50, 100, 10);
INSERT INTO Historico(Documento, Movimento, Data, Quantidade, Saldo, codProduto) VALUES(2, 'C', '2017-04-02',57,200, 10);
INSERT INTO Historico(Documento, Movimento, Data, Quantidade, Saldo, codProduto) VALUES(3, 'E', '2017-05-02',68,300, 10);
INSERT INTO Historico(Documento, Movimento, Data, Quantidade, Saldo, codProduto) VALUES(4, 'A', '2017-03-07',156,400, 10);
INSERT INTO Historico(Documento, Movimento, Data, Quantidade, Saldo, codProduto) VALUES(5, 'V', '2017-04-02',345,500, 1);
INSERT INTO Historico(Documento, Movimento, Data, Quantidade, Saldo, codProduto) VALUES(6, 'V', '2017-06-02',134,350, 2);
INSERT INTO Historico(Documento, Movimento, Data, Quantidade, Saldo, codProduto) VALUES(7, 'V', '2017-02-02',135,456, 3);

SELECT h.Documento, h.Movimento, h.Data, h.Quantidade, h.Saldo, h.CodProduto
FROM Historico h
WHERE (h.codProduto = 10)
ORDER BY h.Documento and h.Data;

-- Questão 53 -- 
SELECT COUNT(c.codCidade) QTDCIDADE
FROM Cidade c
WHERE (UF = 'SP');

-- Questão 54 -- 

SELECT c.CodCliente
FROM
(
	SELECT p.CodCliente, MAX(p.ValorTotal) AS VALOR
	FROM Pedido p
	WHERE (YEAR(p.Data) = 2017) AND (Month(p.DATA) = 05)
	GROUP BY p.CodCliente
    ORDER BY VALOR DESC
)c
LIMIT 1;

-- Questão 55 --
SELECT COUNT(p.CodPedido)
FROM Pedido p
WHERE (month(p.Data) = 3) AND (p.ValorTotal > 500);

-- Questão 56 --
SELECT COUNT(c.CodCliente)
FROM Cliente c
WHERE (c.CodCidade = 1);

-- Questão 57 --
SELECT  c.nome
FROM Cliente c
WHERE (c.email LIKE '%zipmail.com.br%')
ORDER BY c.nome;

-- Questão 58 --
SELECT DISTINCT p.codCliente
FROM Pedido p
WHERE (month(p.Data) = 12)  AND (YEAR(p.Data) = 2016);

-- Questão 59 -- 

SELECT PEDIDOS.codPedido 
FROM 
(
	SELECT p.Codpedido, MAX(p.ValorTotal) As QTD
	FROM Pedido p
	WHERE YEAR(p.Data) = 2017
	GROUP BY p.codPedido
	LIMIT 10
    
    
)PEDIDOS
ORDER BY QTD;

-- Questão 60 --

INSERT INTO ItemPedido (codPedido, CodProduto, Quantidade, ValorUnitario) Values (1, 2, 500, 1.1);
INSERT INTO ItemPedido (codPedido, CodProduto, Quantidade, ValorUnitario) Values (2, 2, 456, 1.1);
INSERT INTO ItemPedido (codPedido, CodProduto, Quantidade, ValorUnitario) Values (3, 2, 786, 1.1);
INSERT INTO ItemPedido (codPedido, CodProduto, Quantidade, ValorUnitario) Values (7, 2, 450, 1.1);

-- Não Entendi Bem --
SELECT AVG(p.Quantidade) As MEDIA
FROM ItemPedido p
WHERE (p.CodProduto = 50);

-- Questão 61 --

SELECT item.codPedido

FROM
(
	SELECT codPedido, MAX(ip.Quantidade) as QTD 
	FROM ItemPedido ip 
	WHERE (ip.CodProduto = 2)
    GROUP BY codPedido
    ORDER BY QTD
  
 )item
LIMIT 1;

-- Questão 62 --

SELECT PRODUTOS.Descricao
FROM 
(
	SELECT p.Descricao, MIN(p.Estoque) Menor
	FROM Produto p
	WHERE (p.Estoque <> 0)
	GROUP BY p.descricao
	ORDER BY Menor
)PRODUTOS
LIMIT 20;

-- Questão 63 --

SELECT SUM(p.ValorTotal) as ValorTotalPedido
FROM Pedido p
WHERE (YEAR(p.Data) = 2017) AND (Month(p.DATA) = 02);

-- Questão 64 --

SELECT SUM(r.ValorTotal) as ValorTotalPedido
FROM Requisicao r
WHERE (YEAR(r.Data) = 2017) AND (Month(r.DATA) = 02);

-- Questão 65 --
SELECT Req.CodRequisicao
FROM 
(
	SELECT r.CodRequisicao, MIN(r.ValorTotal) as QTD
	FROM Requisicao r
	WHERE (YEAR(r.Data) = 2017)
	GROUP BY r.CodRequisicao
    ORDER BY QTD
)Req
LIMIT 10;

-- Questão 66 --

SELECT Cli.codCliente
FROM 
(
	SELECT p.CodCliente, COUNT(p.codPedido) as QTD
	FROM Pedido p
	WHERE (YEAR(p.Data) = 2017) AND (Month(p.Data) = 02)
	GROUP BY p.codCliente
    HAVING QTD > 10    
) Cli;

-- Questão 67 --

SELECT c.UF , COUNT(c.codCidade) as QTDCIDADE
FROM Cidade c
GROUP BY c.UF;

-- Questão 68 --

SELECT h.codProduto, AVG(h.Quantidade) as MediaVendida
From Historico h
WHERE(h.Movimento = 'V')
GROUP BY h.codProduto; 

-- Questão 69 --
SELECT Cid.UF
FROM
(
SELECT c.UF , COUNT(c.codCidade) as QTDCIDADE
FROM Cidade c
GROUP BY c.UF
HAVING QTDCIDADE > 15
)Cid;

-- Questão 70 --

SELECT COUNT(c.CodCliente) AS QTD
FROM cliente c
WHERE (c.nome LIKE 'M%');

-- Questão 71 --

SELECT p.CodTipoProduto, COUNT(p.codProduto) as QTDPRODUTO
FROM TipoProduto p
GROUP BY p.CodTipoProduto;

-- Questão 72 --

SELECT p.CodPedido, p.ValorTotal
FROM Pagamento p
WHERE (p.DataVencimento < '2017-07-10') AND (p.ValorPago <= 0);

-- Questão 73 --

SELECT p.codCliente As CLIENTES, COUNT(p.Codpedido) AS PEDIDOS, SUM(p.ValorTotal) VALORTOTAL
FROM pedido p 
GROUP BY p.codCliente
ORDER BY VALORTOTAL;

-- Questão 74 --
SELECT p.Descricao
FROM historico h
	INNER JOIN produto p ON h.codProduto = p.codProduto
WHERE(h.Quantidade * p.Preco > 1000) and (h.Movimento = 'C'); 

-- Questão 75 --


-- Questão 76 --

-- Nao consegui, mas ...
SELECT h.codProduto, SUM(h.Quantidade) as Vendido, SUM(h.Quantidade) as Adquirido
FROM Historico h
WHERE (h.Movimento = 'V') OR (h.Movimento = 'A')
GROUP BY h.CodProduto;
---

SELECT h.codProduto, h.Vendido, h.Adquirido 
FROM
(
SELECT h.codProduto, SUM(h.Quantidade) as Vendido
FROM Historico h
WHERE (h.Movimento = 'V')
GROUP BY h.CodProduto
UNION
SELECT h.codProduto, SUM(h.Quantidade) as Adquirido
FROM Historico h
WHERE (h.Movimento = 'A')
GROUP BY h.codProduto;
) 
SELECT Prod.CodProduto, Prod.Vendido
FROM 
(
	SELECT h.codProduto, SUM(h.Quantidade) as Vendido
	FROM Historico h
	WHERE (h.Movimento = 'V')
	GROUP BY h.CodProduto
) Prdo

(
	SELECT h.codProduto, SUM(h.Quantidade) as Adquirido
	FROM Historico h
	WHERE (h.Movimento = 'A')
	GROUP BY h.codProduto;
) prd;



INSERT INTO ItemRequisicao(CodRequisicao, CodProduto, Quantidade, ValorUnitario)
VALUES(1, 1, 300, 1.1);

INSERT INTO ItemRequisicao(CodRequisicao, CodProduto, Quantidade, ValorUnitario)
VALUES(2, 2, 234, 2.2);

INSERT INTO ItemRequisicao(CodRequisicao, CodProduto, Quantidade, ValorUnitario)
VALUES(3, 3, 300, 3.3);

INSERT INTO ItemRequisicao(CodRequisicao, CodProduto, Quantidade, ValorUnitario)
VALUES(4, 4, 632, 4.4);

INSERT INTO ItemRequisicao(CodRequisicao, CodProduto, Quantidade, ValorUnitario)
VALUES(5, 5, 320, 5.5);

INSERT INTO ItemRequisicao(CodRequisicao, CodProduto, Quantidade, ValorUnitario)
VALUES(6, 6, 132, 6.6);

INSERT INTO ItemRequisicao(CodRequisicao, CodProduto, Quantidade, ValorUnitario)
VALUES(7, 7, 123, 7.7);

INSERT INTO ItemRequisicao(CodRequisicao, CodProduto, Quantidade, ValorUnitario)
VALUES(8, 8, 231, 8.8);

INSERT INTO ItemRequisicao(CodRequisicao, CodProduto, Quantidade, ValorUnitario)
VALUES(9, 9, 234, 9.9);

INSERT INTO ItemRequisicao(CodRequisicao, CodProduto, Quantidade, ValorUnitario)
VALUES(10, 10, 332, 11.1);

-- Questão 77 --

SELECT DAY(p.Data) as DIA, COUNT(codPedido) QTD
FROM pedido p
WHERE(Month(p.Data) = 5)
GROUP BY DIA;

-- Questão 78 --
SELECT SUM(p.NumParcela) as PARCELAS
FROM Pagamento p
WHERE(p.Desconto > 0) AND (month(p.DataPagamento) = 5) AND (YEAR(p.DataPagamento) = 2017);

-- Questão 79 --

SELECT r.CodFornecedor, SUM(r.ValorTotal) as TOTAL
FROM Requisicao r
GROUP BY r.CodFornecedor;

-- Questão 80 --
SELECT F.CodFornecedor
FROM
(
	SELECT r.CodFornecedor, COUNT(r.codRequisicao) as REQUISICOES
	FROM Requisicao r
	GROUP BY r.CodFornecedor
	HAVING REQUISICOES > 50
)F;

-- Questão 81 --

SELECT c.nome, c.email
FROM cliente c
UNION
SELECT f.nome, f.email
FROM fornecedor f;

-- Questão 82 --
SELECT 'Descontos' AS Movimento, SUM(Desconto) AS Valor
FROM Pagamento
WHERE (DataPagamento >= '2017-05-01') and (DataPagamento <= '2017-05-31')
UNION
SELECT  'Acréscimos' AS Movimento, SUM(Acrescimo) AS Valor
FROM Pagamento
WHERE (DataPagamento >= '2017-05-01') and (DataPagamento <= '2017-05-31')
UNION 
SELECT 'Diferênça' AS Movimento, x.Valor + y.Valor 
FROM (
		(
		SELECT 'Descontos' AS Movimento, SUM(Desconto) AS Valor
		FROM Pagamento
        WHERE (DataPagamento >= '2017-05-01') and (DataPagamento <= '2017-05-31')) x,
		(
	 	SELECT  'Acréscimos' AS Movimento, SUM(Acrescimo) AS Valor
        FROM Pagamento
        WHERE (DataPagamento >= '2017-05-01') and (DataPagamento <= '2017-05-31'))y
	 );
	 
	 
	 
SELECT 'Descontos' as Movimento, SUM(Desconto) as Valor
FROM Pagamento
UNION
SELECT 'Acrescimo' as Movimento, SUM(Acrescimo) as Valor
FROM Pagamento
UNION
SELECT 'Diferença' as Movimento, x.Valor + y.Valor
FROM (
	(
	
	SELECT 'Descontos' as Movimento, SUM(Desconto) as Valor
	FROM Pagamento
	 )x,
	 
	 (
	 SELECT 'Acrescimo' as Movimento, SUM(Acrescimo) as Valor
	 FROM Pagamento )y
 );

	 -- Questão 83 --

SELECT p.codPedido as Pedido_Parcela, ped.Data as DATA_Vencimento, SUM(ValorPago) As Valor
FROM Pagamento p INNER JOIN Pedido ped ON p.codPedido = ped.codPedido
WHERE(ped.CodPedido = 4)
GROUP BY p.codPedido, ped.Data
UNION 
SELECT p.numParcela as Pedido_Parcela, p.DataVencimento As DATA_Vencimento, p.valorPago as Valor 
FROM Pagamento p INNER JOIN pedido ped ON p.Codpedido = ped.codPedido
WHERE(ped.CodPedido = 4);


-- Questão 84--

SELECT 'Pedidos' AS Movimento, COUNT(CodPedido) as Quantidade, Sum(ValorTotal) AS ValorTotal
FROM Pedido
WHERE(Data >='2017-05-01') AND (Data <= '2017-05-31')
UNION
SELECT 'Requisições' AS Movimento, COUNT(CodRequisicao) as Quantidade, sum(ValorTotal) as ValorTotal
FROM Requisicao 
WHERE(Data >= '2017-05-01') AND (Data <= '2017-05-31')
UNION
	SELECT 'Total' , x.Quantidade + y.Quantidade, x.ValorTotal - y.ValorTotal
	FROM (
    
    SELECT COUNT(CodPedido) as Quantidade, Sum(ValorTotal) AS ValorTotal
	FROM Pedido
	WHERE(Data >='2017-05-01') AND (Data <= '2017-05-31')
    ) x,
    
    (
    SELECT COUNT(CodRequisicao) as Quantidade, sum(ValorTotal) as ValorTotal
	FROM Requisicao 
	WHERE(Data >= '2017-05-01') AND (Data <= '2017-05-31')
    )y;


-- Questão 85--

SELECT codRequisicao as Código, Data as DataRequisicão, ValorTotal as Valor
FROM Requisicao 
WHERE(Month(Data) = 04) AND (YEAR(Data)= 2017)
UNION 
SELECT 'Total' as Código, '',	SUM(x.Valor) as Valor
FROM
	(
		SELECT codRequisicao as Código, Data as DataRequisicão, ValorTotal as Valor
		FROM Requisicao 
		WHERE(Month(Data) = 04) AND (YEAR(Data)= 2017)
		)x;
	
	
	
	-- Questão 86 --
SELECT c.nome
FROM Cliente c INNER JOIN Cidade Cid ON c.codCidade = Cid.codCidade
WHERE (Cid.nome = 'Muriaé') AND (Cid.UF = 'MG');

-- Questão 87 --
SELECT DISTINCT p.Descricao
FROM produto p INNER JOIN Itempedido ip ON p.codProduto = ip.codProduto
			   INNER JOIN Pedido ped ON ip.CodPedido = ped.codPedido
WHERE(ped.Data = '2017-06-26');

-- Questão 88 --
SELECT f.nome, p.Descricao
FROM Produto p
	INNER JOIN ItemRequisicao ir ON p.codProduto = ir.CodProduto
	INNER JOIN Requisicao req ON ir.codRequisicao = req.codRequisicao
	INNER JOIN Fornecedor f ON req.CodFornecedor = f.CodFornecedor
WHERE(req.Data = '2017-06-26');

-- Questão 89 --
SELECT COUNT(p.codPedido) as Pedidos , SUM(p.ValorTotal) as Valor
FROM pedido p
	INNER JOIN Cliente c ON p.CodCliente = c.CodCliente
WHERE(c.nome = 'José da Silva Andrade');

-- Questão 90 --
SELECT SUM(h.Quantidade) as QuantidadeTotal
FROM Historico h
	INNER JOIN Produto prod ON h.CodProduto = prod.CodProduto
WHERE(prod.Descricao = 'Refrigerante Coca-Cola') AND (h.Movimento = 'V') AND (Month(h.Data) = 5) AND (YEAR(h.Data) = 2017);

-- Questão 91 --
SELECT COUNT(f.codFornecedor) as FornecedoresMG
FROM Fornecedor f 
	INNER JOIN cidade cid ON f.CodCidade = cid.CodCidade
WHERE(cid.nome = 'Belo Horizonte') AND (cid.UF = 'MG');

-- Questão 92 --
SELECT prod.Descricao, h.Documento, h.Data, h.Quantidade, h.Saldo
FROM Historico h
	INNER JOIN Produto prod ON h.CodProduto = prod.CodProduto
WHERE(prod.Descricao = 'Goiabada')AND (h.Movimento = 'E');

-- Questão 93 --
SELECT p.codPedido
FROM Pedido p
	INNER JOIN Cliente cli ON p.CodCliente = cli.CodCliente
	INNER JOIN ItemPedido ip ON p.CodPedido = ip.CodPedido
	INNER JOIN Produto prod ON ip.CodProduto = prod.CodProduto
	INNER JOIN Historico h ON ip.CodProduto = h.CodProduto
WHERE(cli.nome = 'Jacira Ciqueira') AND (h.Movimento = 'A');

-- Questão 94 --
SELECT Prod.codProduto, prod.Descricao
FROM produto prod
	INNER JOIN TipoProduto tp ON prod.codTipoProduto = tp.CodTipoProduto
WHERE(tp.Descricao = 'Bebidas')
ORDER BY prod.Descricao;

-- Questão 95 --
SELECT pag.NumParcela
FROM Pagamento pag
	INNER JOIN Pedido ped ON pag.codPedido = ped.CodPedido
	INNER JOIN ItemPedido ip ON ped.CodPedido = ip.CodPedido
	INNER JOIN Produto prod ON ip.CodProduto = prod.CodProduto
	INNER JOIN Historico h ON prod.CodProduto = h.CodProduto
WHERE(h.Movimento = 'A') AND (Month(h.Data) = 1) AND (YEAR(h.Data) = 2017);

-- Questão 96 --
SELECT pag.NumParcela
FROM Pagamento pag
	INNER JOIN Pedido ped ON pag.codPedido = ped.CodPedido
	INNER JOIN Cliente cli ON ped.CodCliente = cli.CodCliente
	INNER JOIN ItemPedido ip ON ped.CodPedido = ip.CodPedido
	INNER JOIN Produto prod ON ip.CodProduto = prod.CodProduto
	INNER JOIN Historico h ON prod.CodProduto = h.CodProduto
WHERE(h.Movimento = 'A') AND (cli.nome = 'Ronaldinho Gaúcho') AND (pag.DataVencimento > '2017-07-14') AND (pag.DataPagamento IS NULL OR 0);

-- Questão 97 --
SELECT p.codPedido
FROM Pedido p
	INNER JOIN Cliente c ON p.codCliente = c.CodCliente
	INNER JOIN Cidade cid ON c.codCidade = cid.Codcidade
WHERE(cid.nome = 'Vitória') AND (cid.UF = 'ES') AND (p.ValorTotal > 1500);

-- Questão 98 --
SELECT DISTINCT c.nome, c.email
FROM Cliente c
	INNER JOIN pedido ped ON c.codCliente = ped.CodCliente
	INNER JOIN pagamento pag ON ped.CodPedido = pag.Codpedido
WHERE(pag.Desconto > 0);

-- Questão 99 --
SELECT f.nome, f.email
FROM Fornecedor f
	INNER JOIN Requisicao req ON f.CodFornecedor = req.CodFornecedor
WHERE(req.ValorTotal > 10000) AND (Month(req.Data) = 1) AND (YEAR(req.Data) = 2017);

-- Questão 100 --
SELECT c.nome, COUNT(p.codPedido) as QTDPEDIDOS
FROM Cliente c
	INNER JOIN Pedido p ON c.CodCliente = p.CodCliente
WHERE(Month(p.Data) = 4) AND (YEAR(p.Data) = 2017)
GROUP BY c.nome;


-- Questão 101

SELECT 1 as COL, UF, Ci.Nome as Cidade, Count(cl.CodCliente) as TotalClientes
FROM cidade Ci
	INNER JOIN cliente cl ON ci.CodCidade = cl.codCidade
GROUP BY Ci.UF, Ci.Nome
UNION 
SELECT 2 as COL,'Total', ' ', Count(cl.CodCliente)
FROM cidade Ci2 
	INNER JOIN Cliente cl ON Ci2.CodCidade = cl.Codcidade
ORDER BY COL, UF, Cidade;

-- Questão 102 --

SELECT c.Nome as Clientes, p.valorTotal as TotalCompras
FROM Cliente c INNER JOIN Pedido p ON c.CodCliente = p.CodCliente
UNION 
SELECT 'Total' as Clientes, SUM(p.ValorTotal)
FROM Cliente c INNER JOIN Pedido p ON c.CodCliente = p.CodCliente;


-- Questão 103 --
SELECT f.nome, f.email
FROM Fornecedor f
	INNER JOIN Cidade cid ON f.CodCidade = Cid.CodCidade
WHERE(Cid.UF = 'RJ') AND (Cid.nome = 'Rio de Janeiro');

-- Questão 104 --

SELECT c.Nome
from cliente c 
WHERE c.CodCliente NOT IN (
	SELECT DISTINCT c.CodCliente
	FROM cliente c 
		INNER JOIN pedido ped ON c.CodCliente = ped.codCliente
	WHERE(YEAR(ped.Data) = 2017))
	
ORDER BY c.nome;

-- Questão 105 --
SELECT p.Descricao
FROM Produto p
WHERE p.Descricao NOT IN (
	SELECT DISTINCT prod.Descricao
	FROM produto prod
		INNER JOIN Historico h ON prod.CodProduto = h.codProduto
		INNER JOIN ItemPedido ip ON prod.codProduto = ip.codProduto
		INNER JOIN Pedido ped ON ip.CodPedido = ped.Codpedido
	WHERE(h.Saldo > 10) AND (Month(h.Data) = 5) AND (YEAR(h.Data) = 2017);


	
-- Questão 106 --
-- ainda nao sei direito;
DELETE FROM Cliente 
WHERE 
    (
		Nome = 
	( 
	SELECT x.nome
	FROM(
		SELECT c.Nome
		from cliente c 
		WHERE c.CodCliente NOT IN (
			SELECT DISTINCT c.CodCliente
			FROM cliente c 
				INNER JOIN pedido ped ON c.CodCliente = ped.codCliente
			WHERE(YEAR(ped.Data) = 2017)
	))x));
	
	
-- Questão 107 --

DELETE FROM Produto 
WHERE Produto.Descricao = 
	(
		SELECT p.Descricao
		FROM produto p
			INNER JOIN Historico h ON p.codProduto = h.codProduto
		WHERE(h.Movimento IS NOT NULL) AND (h.Saldo = 0)
	);
	
-- Questão 108 --

DELETE FROM Cidade 
WHERE nome NOT IN (
SELECT x.nome 
FROM( 
	SELECT c.nome
	FROM cidade c
		INNER JOIN Cliente cli ON c.CodCidade = cli.CodCidade
		INNER JOIN Fornecedor f ON c.CodCidade = f.CodCidade)x
);

DELETE FROM Cidade
WHERE(codCidade NOT IN (
	SELECT x.codCidade FROM(
		Select CodCidade
        FROM Cliente 
        UNION
        SELECT codCidade
        FROM Fornecedor)x)
);
		
		
-- Questão 109 --
UPDATE Produto 
SET Preco = Preco - preco * 0.15
WHERE Descricao IN

(	SELECT x.Descricao FROM (
	SELECT DISTINCT p.Descricao
	FROM Produto p
		INNER JOIN Historico h ON p.CodProduto = h.CodProduto
	WHERE(h.Movimento <> 'V') AND (YEAR(h.Data) = 2017)
)x);