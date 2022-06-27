-- Heitor Lorenção Busato - 2015207975

--# Questão 01

CREATE OR REPLACE PROCEDURE baixa_estoque(codproduto IN NUMBER,	Quantidadevendida IN NUMBER)
IS
	x NUMBER;
	y NUMBER;
BEGIN
		SELECT p.CodProduto
		INTO x
		FROM
			Produto p
				INNER JOIN Historico H
					ON p.CodProduto = H.CodProduto 
		WHERE
			H.Quantidade > y
			
		IF(x IS NULL) THEN
			
			INSERT INTO ProdutoEsgotado(Data, CodProduto, SaldoEstoque, Qtd)
			VALUES (CodigoProduto, NomeProduto, Variavel1);
		ELSE
			-- Fazer Update No Estoque
			UPDATE Historico
			SET	Quantidade = Quantidade - x
			WHERE
				Historico.CodigoProduto = produto;
		END IF;
END
/
--# Questão 02

CREATE OR REPLACE PROCEDURE compara_estoque(codProd IN int, EstMin IN VARCHAR)
BEGIN
	DECLARE reg int;
    
    SELECT count(*)
		into reg 
	FROM Produto
	WHERE Estoque < EstMin and CodProduto = codProd;
	
    IF reg > 0 THEN
		
		INSERT INTO Requisicao (CodRequisicao, CodFornecedor, Data, ValorTotal)
			VALUES (CodRequisicao, CodFornecedor, Data, ValorTotal);
        INSERT INTO ItemRequisicao (CodRequisicao, CodProduto, Quantidade, ValorUnitario) 
			VALUES (CodRequisicao, codProd, Quantidade, ValorUnitario);
	
	ELSE
		UPDATE Produto
		SET EstoqueMinimo := EstMinimo;
	END IF;
END
/
--# Questão 03

CREATE OR REPLACE PROCEDURE reajusta_preco(CodProduct IN NUMBER, taxa IN NUMBER)
AFTER UPDATE ON Produto
FOR EACH ROW
BEGIN
		UPDATE Produto 
		SET PrecoVenda = PrecoVenda - (PrecoVenda * (taxa/100))
		WHERE Produto.CodProduto = CodProduct;
END
/

--# Questão 04

CREATE OR REPLACE PROCEDURE quantidade_vendida(CodProduct IN NUMBER)
BEGIN
	DECLARE Qtd double;
		SELECT SUM(Quantidade) 
			INTO Qtd
		FROM ItemPedido 
		WHERE CodProduto = CodProduct;
		
		
    	INSERT INTO ProdutoVenda (CodProduto, Data, QtdVendida)
			VALUES (CodProduct, Data, QtdTotal);
    
END
/

--# Questão 05

CREATE OR REPLACE PROCEDURE cria_produto_fornecedor
BEGIN
	CREATE TABLE ProdutoFornecedor(

		CodProduto NUMBER NOT NULL,
		CodFornecedor  NUMBER NOT NULL,
			CONSTRAINT pkProdutoFornecedor
				PRIMARY KEY (CodProduto, CodFornecedor),
			CONSTRAINT fkProdutoFornecedorFornecedor
			FOREIGN KEY (CodFornecedor) 
				REFERENCES Fornecedor(CodFornecedor),
			CONSTRAINT fkProdutoFornecedorProduto 
				FOREIGN KEY (CodProduto) 
			REFERENCES Produto(CodProduto)
					
	);
	INSERT INTO ProdutoFornecedor(CodProduto, CodFornecedor) 
			SELECT (ItemRequisicao.CodProduto, Requisicao.CodFornecedor) 
			FROM ItemRequisicao 
    	INNER JOIN Requisicao
    	ON ItemRequisicao.CodRequisicao = Requisicao.CodRequisicao;	
END
/