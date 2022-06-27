-- Heitor Lorenção Busato - 2015207975

--# Questão 01

CREATE TRIGGER tInsertItemRequisicao 
AFTER INSERT ON ItemRequisicao
FOR EACH ROW
BEGIN
	UPDATE Produto 
			SET 
				Estoque = Estoque + NEW.Quantidade
	WHERE 
			CodProduto = NEW.CodProduto;	
	
	UPDATE Requisicao 
		SET 
			ValorTotal = (ValorTotal + (NEW.Quantidade * NEW.ValorUnitario))
	WHERE 
		CodRequisicao = NEW.CodRequisicao;
	
	INSERT INTO Historico
			(
			Documento, CodProduto, Movimento, Data, Quantidade, Saldo
			)
	VALUES
	(
		NEW.CodRequisicao, NEW.CodProduto,'RE',
		(SELECT Data FROM Requisicao 
			WHERE CodRequisicao = NEW.CodRequisicao),
		NEW.Quantidade,
		(SELECT Estoque FROM Produto WHERE CodProduto = NEW.CodProduto)		
	);	
END;

--# Questão 02

CREATE TRIGGER tInsertItemPedido 
AFTER INSERT ON ItemPedido
FOR EACH ROW
BEGIN
	UPDATE Produto 
		SET 
			Estoque = Estoque - NEW.Quantidade
	WHERE 
		CodProduto = NEW.CodProduto;	
	
	UPDATE Pedido 
		SET 
			ValorTotal = (ValorTotal + (NEW.Quantidade * NEW.ValorUnitario))
	WHERE 
		CodPedido = NEW.CodPedido;
	
	INSERT INTO Historico
		(
		Documento, CodProduto, Movimento, Data, Quantidade, Saldo
		)
	VALUES
	(
		NEW.CodPedido,
		NEW.CodProduto,
		'S',
		(SELECT Data FROM Pedido WHERE CodPedido = NEW.CodPedido),
		NEW.Quantidade,
		(SELECT Estoque FROM Produto WHERE CodProduto = NEW.CodProduto)		
	);	
END;

--# Questão 03

CREATE TRIGGER tAtualizaEstoque 
AFTER UPDATE ON ItemRequisicao
FOR EACH ROW
BEGIN
	UPDATE Produto 
		SET Estoque = Estoque - OLD.Quantidade
	WHERE CodProduto = OLD.CodProduto;	
	
	UPDATE Requisicao 
		SET ValorTotal = ValorTotal - (OLD.Quantidade * OLD.ValorUnitario)
	WHERE CodRequisicao = OLD.CodRequisicao;
	
	DELETE FROM Historico
	WHERE
	(
		(Documento = OLD.CodRequisicao) AND 
		(CodProduto = OLD.CodProduto) AND
		(Movimento = 'E')
	);
	
	UPDATE Produto 
		SET Estoque = Estoque + NEW.Quantidade
	WHERE CodProduto = NEW.CodProduto;
	
	UPDATE Requisicao 
		SET ValorTotal = (ValorTotal + (NEW.Quantidade * NEW.ValorUnitario))
	WHERE CodRequisicao = OLD.CodRequisicao;
	
	INSERT INTO Historico
	(
		Documento, CodProduto, Movimento, Data, Quantidade, Saldo
	)
	VALUES
	(
		 NEW.CodRequisicao, NEW.CodProduto, 'E',
		(SELECT Data 
			FROM Requisicao 
				WHERE CodRequisicao = NEW.CodRequisicao), NEW.Quantidade,
		(SELECT Estoque 
			FROM Produto 
				WHERE CodProduto = NEW.CodProduto)
	);
END;

--# Questão 04

CREATE TRIGGER tAtualizaPedido 
AFTER UPDATE ON ItemPedido
FOR EACH ROW
BEGIN
	UPDATE Produto 
			SET Estoque = Estoque - OLD.Quantidade
	WHERE CodProduto = OLD.CodProduto;
	
	UPDATE Pedido 
		SET ValorTotal = (ValorTotal - (OLD.Quantidade * OLD.ValorUnitario))
	WHERE CodPedido = OLD.CodPedido;	
	
	DELETE FROM Historico
	WHERE
	(
		(Documento = OLD.CodPedido) AND
		(CodProduto = OLD.CodProduto) AND
		(Movimento = 'S')	
	);
	
	UPDATE Produto 
		SET Estoque = Estoque + NEW.Quantidade
	WHERE CodProduto = NEW.CodProduto;
	
	UPDATE Pedido 
		SET ValorTotal = (ValorTotal + (NEW.Quantidade * NEW.ValorUnitario))
	WHERE CodPedido = OLD.CodPedido;
	
	INSERT INTO Historico
	(
		Documento,CodProduto,Movimento,Data,Quantidade,Saldo
	)
	VALUES
	(
		NEW.CodPedido, NEW.CodProduto,'S',
		(SELECT Data
			FROM Pedido 
				WHERE CodPedido = :NEW.CodPedido), NEW.Quantidade,
		(SELECT Estoque 
			FROM Produto 
				WHERE CodProduto = NEW.CodProduto)
	);
END;

--# Questão 05

CREATE TRIGGER tAtualizaEstoque 
BEFORE UPDATE ON ItemRequisicao
FOR EACH ROW
BEGIN
	UPDATE Produto SET Estoque = Estoque + OLD.Quantidade
	WHERE CodProduto = OLD.CodProduto;
	
	UPDATE Requisicao 
	SET ValorTotal = (ValorTotal + (OLD.Quantidade * OLD.ValorUnitario))
	WHERE CodRequisicao = OLD.CodRequisicao;
	
	DELETE FROM Historico
	WHERE
	(
		(Documento = OLD.CodRequisicao) AND
		(CodProduto = OLD.CodProduto) AND
		(Movimento = 'ES')	
	);
END;

--# Questão 06 ???????????????????????????????????????


