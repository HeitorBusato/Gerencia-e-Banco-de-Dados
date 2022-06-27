-- Heitor Lorenção Busato - 2015207975

#Questao 01

CREATE OR REPLACE TRIGGER Atualiza_valor
AFTER INSERT ON PrecoAtividade
FOR EACH ROW
BEGIN
	UPDATE AtividadeDependente, AtividadeSocio
	SET AtividadeDependente.Valor = PrecoAtividade.Valor AND AtividadeSocio.Valor = PrecoAtividade.Valor 
	FROM AtividadeDependente 
		INNER JOIN Atividade
				ON AtividadeDependente.CodAtividade = Atividade.CodAtividade
		INNER JOIN AtividadeSocio
				ON Atividade.CodAtividade = AtividadeSocio.CodAtividade
		INNER JOIN PrecoAtividade
				ON AtividadeSocio.CodAtividade=PrecoAtividade.CodAtividade
	WHERE ((PrecoAtividade.Mes) = 10) AND ((PrecoAtividade.Ano) = 2020);
END;
/

#Questao 02

CREATE OR REPLACE PROCEDURE realiza_pagamento(
	mes in date, 
	ano in date
	nomeSocio in varchar2
	)
BEGIN
	DECLARE reg INT;
    SELECT COUNT(*) into reg 
	FROM Mensalidade
		INNER JOIN Socio 
				ON Mensalidade.CodSocio=Socio.CodSocio
	WHERE Mensalidade.ValorPago > 0 
			AND (Mensalidade.Mes) = (mesMensalidade -1)
			AND (Mensalidade.Ano) = ano
			AND Socio.Nome = nomeSocio;
	IF reg > 0 THEN
		UPDATE Mensalidade 
		SET ValorPago = (ValorPago -(ValorPago*0.1)) 
		FROM Mensalidade 
			INNER JOIN Socio 
					ON Mensalidade.CodSocio = Socio.CodSocio
		WHERE (Socio.NumDependentes >= 5) 
			AND (Mensalidade.Mes) = mes;
END;
/

#Questao 03

CREATE OR REPLACE PROCEDURE processa_mensalidade(
	mes in date, 
	ano in date
	)
BEGIN
	SELECT SUM(QtdTotal) AS Total FROM
	(
		SELECT SUM(CodAtividade) AS QtdTotal 
		FROM AtividadeSocio 
				INNER JOIN Socio 
					ON AtividadeSocio.CodSocio = Socio.CodSocio 
		WHERE Socio.Ativo = 1 
				AND (AtividadeSocio.DataTermino = mes)
				AND (AtividadeSocio.DataTermino = ano)
			UNION
				SELECT SUM(CodAtividade) AS QtdTotal 
				FROM AtividadeDependente 
					INNER JOIN Dependente 
							ON AtividadeDependente.CodDependente = Dependente.CodDependente 
					INNER JOIN Socio 
							ON Dependente.CodSocio = Socio.CodSocio
	)AS QtdAtividades
END;
/
