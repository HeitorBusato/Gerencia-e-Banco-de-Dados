-- Heitor Lorenção Busato - 2015207975

#Questao 01

CREATE OR REPLACE TRIGGER Insere_Partida
AFTER INSERT ON Partida
FOR EACH ROW
BEGIN
    IF(:NEW.GolsClube1 > :NEW.GolsClube2) THEN
        UPDATE ClubeCampeonato
        SET pontos = pontos + 3
		WHERE 
		    ClubeCampeonato.codClube = :NEW.codClube1
		    AND
		    ClubeCampeonato.codcampeonato = :NEW.codcampeonato
		    AND
		    ClubeCampeonato.ano = :NEW.Ano;
    ELSE
        IF(:NEW.GolsClube2 > :NEW.GolsClube1) THEN
            UPDATE ClubeCampeonato
            SET pontos = pontos + 3
		    WHERE
                ClubeCampeonato.codClube = :NEW.codClube2
		        AND
		        ClubeCampeonato.codcampeonato = :NEW.codcampeonato
		        AND
		        ClubeCampeonato.ano = :NEW.Ano;
        ELSE
            UPDATE ClubeCampeonato
            SET pontos = pontos + 1
		    WHERE
                (ClubeCampeonato.codClube = :NEW.codClube1 OR ClubeCampeonato.codClube = :NEW.codClube2)
		        AND
		        ClubeCampeonato.codcampeonato = :NEW.codcampeonato
		        AND
		        ClubeCampeonato.ano = :NEW.Ano;
        END IF; 
    END IF;
    
    -- Fazer Update No Estadio
    UPDATE Estadio
    SET 
        NumPartidas = NumPartidas + 1
    WHERE
    	CodEstadio = :NEW.CodEstadio;
END;
/

#Questao 02

-- Já consta na Questão 01
 
CREATE OR REPLACE TRIGGER Atualiza_Estadio
AFTER UPDATE ON Estadio
FOR EACH ROW
BEGIN
   UPDATE Estadio
    SET 
        NumPartidas = NumPartidas + 1
    WHERE
    	CodEstadio = :NEW.CodEstadio;
END;
/

#Questao 03

CREATE OR REPLACE PROCEDURE aumenta_Passe_Jogador(descricao IN VARCHAR,ano_p IN NUMBER)
IS
	x NUMBER;
	y NUMBER;
BEGIN	
	SELECT JCC.CodJogador, MAX(JCC.Gols)
	INTO x, y
	FROM
		JogadorClubeCampeonato JCC
			INNER JOIN ClubeCampeonato CC
				ON JCC.CodClube = CC.CodClube 
				AND JCC.CodCampeonato = CC.CodCampeonato 
				AND JCC.Ano = CC.Ano
		INNER JOIN Campeonato C
			ON C.CodCampeonato = CC.CodCampeonato
	WHERE
		(ROWNUM <= 1 AND C.Descricao = descricao AND JCC.Ano = ano_p)
	GROUP BY JCC.CodJogador;
	
	UPDATE Jogador
	SET ValorPasse = ValorPasse*1.15
	WHERE CodJogador = x;
END aumenta_Passe_Jogador;
/

#Questão 04 

CREATE OR REPLACE PROCEDURE adiciona_rodada(
	dataPartida in date, 
	descricaoCamp in varchar2
	)
IS
 
	CURSOR consulta_partida IS
		SELECT p.CodCampeonato,p.datahora,p.Codpartida
		FROM
			Partida p INNER JOIN Campeonato c 
				ON p.codcampeonato=c.codcampeonato
		WHERE(
			p.datahora=dataPartida AND c.descricao=descricaoCamp);
	numr NUMBER;
	numr2 NUMBER;
	cod NUMBER;

BEGIN	
	SELECT max(codRodada) 
	INTO cod
	FROM Rodada;

	FOR x IN consulta_partida
	LOOP
		SELECT max(NumeroRodada)
		INTO numr
		FROM Rodada r 	
		WHERE(r.descricao=descricaoCamp AND r.datahora=datapartida);
		
		SELECT max(NumeroRodada)
		INTO numr2
		FROM Rodada r  
		WHERE(r.descricao=descricaoCamp AND  r.datahora!=datapartida);
		
		IF(numr IS NULL AND numr2 IS NULL ) THEN
			numr:=1;
		END IF;
		
		IF (numr IS NULL) THEN
			numr:=0;
		END IF;
		
		IF(numr2 IS NOT NULL) THEN
			numr2:=numr2+1;
			numr:=numr2;
		END IF;
		
		IF(cod IS NULL) THEN
			cod:=0;
		END IF;
		
		cod:=cod+1;
		INSERT INTO Rodada VALUES(cod,numr,descricaoCamp,x.CodPartida,x.datahora);
		
	END LOOP;
END;
/