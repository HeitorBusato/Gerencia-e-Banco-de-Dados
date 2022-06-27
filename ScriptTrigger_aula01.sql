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
		'RE',
		(SELECT Data FROM Requisicao 
			WHERE CodRequisicao = NEW.CodRequisicao),
		NEW.Quantidade,
		(SELECT Estoque FROM Produto 
		WHERE CodProduto = NEW.CodProduto)		
	);	
END;
$$ 

DELIMITER $$
CREATE TRIGGER tInsertItemPedido 
AFTER INSERT ON ItemPedido
FOR EACH ROW
BEGIN
	UPDATE Produto SET Estoque = Estoque - NEW.Quantidade
	WHERE CodProduto = NEW.CodProduto;	
	
	UPDATE Pedido 
		SET ValorTotal = ValorTotal + 
			(NEW.Quantidade * NEW.ValorUnitario)
	WHERE CodPedido = NEW.CodPedido;
	
	INSERT INTO Historico
	(Documento, CodProduto, Movimento, Data, Quantidade, Saldo)
	VALUES
	(
		NEW.CodPedido,
		NEW.CodProduto,
		'PS',
		(SELECT Data FROM Pedido 
			WHERE CodPedido = NEW.CodPedido),
		NEW.Quantidade,
		(SELECT Estoque FROM Produto 
		WHERE CodProduto = NEW.CodProduto)		
	);	
END;
$$ 

DELIMITER $$
CREATE TRIGGER tDeleteItemPedido 
BEFORE DELETE ON ItemPedido
FOR EACH ROW
BEGIN
	UPDATE Produto SET Estoque = Estoque + OLD.Quantidade
	WHERE CodProduto = OLD.CodProduto;	
	
	UPDATE Pedido 
		SET ValorTotal = ValorTotal - 
			(OLD.Quantidade * OLD.ValorUnitario)
	WHERE CodPedido = OLD.CodPedido;
	
	INSERT INTO Historico
	(Documento, CodProduto, Movimento, Data, Quantidade, Saldo)
	VALUES
	(
		OLD.CodPedido,
		OLD.CodProduto,
		'PC',
		(SELECT Data FROM Pedido 
			WHERE CodPedido = OLD.CodPedido),
		OLD.Quantidade,
		(SELECT Estoque FROM Produto 
		WHERE CodProduto = OLD.CodProduto)		
	);	
END;
$$ 

DELIMITER $$
CREATE TRIGGER tDeleteItemRequisicao 
BEFORE DELETE ON ItemRequisicao
FOR EACH ROW
BEGIN
	UPDATE Produto SET Estoque = Estoque - OLD.Quantidade
	WHERE CodProduto = OLD.CodProduto;	
	
	UPDATE Requisicao 
		SET ValorTotal = ValorTotal - 
			(OLD.Quantidade * OLD.ValorUnitario)
	WHERE CodRequisicao = OLD.CodRequisicao;
	
	INSERT INTO Historico
	(Documento, CodProduto, Movimento, Data, Quantidade, Saldo)
	VALUES
	(
		OLD.CodRequisicao,
		OLD.CodProduto,
		'RC',
		(SELECT Data FROM Requisicao 
			WHERE CodRequisicao = OLD.CodRequisicao),
		OLD.Quantidade,
		(SELECT Estoque FROM Produto 
		WHERE CodProduto = OLD.CodProduto)		
	);	
END;
$$ 






DELIMITER ;

INSERT INTO Requisicao
(CodRequisicao, CodFornecedor, Data, ValorTotal)
VALUES 
(1, 6, '2017-08-31', 0);

INSERT INTO ItemRequisicao
(CodRequisicao, CodProduto, Quantidade, ValorUnitario)
VALUES
(1, 15, 150, 5);

DROP TRIGGER tInsertItemRequisicao; 

UPDATE Produto SET Estoque = 0
WHERE CodProduto = 15;

DELETE FROM ItemRequisicao
WHERE CodRequisicao = 1;

INSERT INTO Pedido





