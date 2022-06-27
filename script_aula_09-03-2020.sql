DELIMITER $$
CREATE TRIGGER tInsertItemRequisicao 
AFTER INSERT ON ItemRequisicao
FOR EACH ROW
BEGIN
	UPDATE Produto SET Estoque = Estoque + NEW.Quantidade
	WHERE CodProduto = NEW.CodProduto;	
	
	UPDATE Requisicao 
		SET ValorTotal = ValorTotal + 
			(NEW.Quantidade * NEW.ValorUnitario)
	WHERE CodRequisicao = NEW.CodRequisicao;
	
	INSERT INTO Historico
	(Documento, CodProduto, Movimento, Data, Quantidade, Saldo)
	VALUES
	(
		NEW.CodRequisicao,
		NEW.CodProduto,
		'E',
		(SELECT Data FROM Requisicao 
			WHERE CodRequisicao = NEW.CodRequisicao),
		NEW.Quantidade,
		(SELECT Estoque FROM Produto 
		WHERE CodProduto = NEW.CodProduto)		
	);	
END;
$$ 

INSERT INTO Requisicao (CodRequisicao, CodFornecedor, Data, ValorTotal)
VALUES(1, 6, '2020-03-09', 0);

INSERT INTO ItemRequisicao (CodRequisicao, CodProduto, Quantidade, ValorUnitario)
VALUES (1, 18, 2000, 4);

