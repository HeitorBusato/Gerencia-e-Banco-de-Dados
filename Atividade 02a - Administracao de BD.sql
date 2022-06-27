-- Heitor Lorenção Busato - 2015207975

SET FOREIGN_KEY_CHECKS = 0;

-- Criação FolhaPagamento

CREATE DATABASE IF NOT EXISTS FolhaPagamento
	CHARACTER SET latin1;
	
-- Criação Departamento
	
DROP TABLE IF EXISTS FolhaPagamento.departamento;
CREATE TABLE FolhaPagamento.departamento (
	CodDepartamento INT(10) unsigned NOT NULL AUTO_INCREMENT,
	NmDepartamento VARCHAR(50) NOT NULL,
	PRIMARY KEY (CodDepartamento)
)
ENGINE = InnoDB
ROW_FORMAT = Compact
CHARACTER SET latin1 COLLATE latin1_swedish_ci;

-- Criação Funcionário

DROP TABLE IF EXISTS FolhaPagamento.funcionario;
CREATE TABLE FolhaPagamento.funcionario (
	CodFuncionario INT(10) unsigned NOT NULL AUTO_INCREMENT,
	NmFuncionario VARCHAR(50) NOT NULL,
	CodDepartamento INT(10) unsigned NOT NULL DEFAULT '0',
	PRIMARY KEY (CodFuncionario),
	INDEX CodDepartamento (CodDepartamento),
	CONSTRAINT funcionario_ibfk_1 FOREIGN KEY funcionario_ibfk_1 (CodDepartamento)
	REFERENCES FolhaPagamento.departamento (CodDepartamento)
	ON DELETE RESTRICT
	ON UPDATE RESTRICT
)
ENGINE = InnoDB
ROW_FORMAT = Compact
CHARACTER SET latin1 COLLATE latin1_swedish_ci;

-- Criação Pagamento

DROP TABLE IF EXISTS FolhaPagamento.pagamento;
CREATE TABLE FolhaPagamento.pagamento (
	CodPagamento INT(10) unsigned NOT NULL AUTO_INCREMENT,
	CodFuncionario INT(10) unsigned NOT NULL DEFAULT '0',
	DataPagamento DATE NOT NULL DEFAULT '0000-00-00',
	Historico VARCHAR(100) NOT NULL,
	Valor DECIMAL(10, 0) NOT NULL DEFAULT '0',
	PRIMARY KEY (CodPagamento),
	INDEX CodFuncionario (CodFuncionario),
	CONSTRAINT pagamento_ibfk_1 FOREIGN KEY pagamento_ibfk_1 (CodFuncionario)
		REFERENCES FolhaPagamento.funcionario (CodFuncionario)
		ON DELETE RESTRICT
		ON UPDATE RESTRICT
)
ENGINE = InnoDB
ROW_FORMAT = Compact
CHARACTER SET latin1 COLLATE latin1_swedish_ci;

-- Criação Usuário

DROP TABLE IF EXISTS FolhaPagamento.usuario;
CREATE TABLE FolhaPagamento.usuario (
	CodUsuario INT(10) unsigned NOT NULL AUTO_INCREMENT,
	NmUsuario VARCHAR(50) NOT NULL,
	Login VARCHAR(20) NOT NULL,
	Senha VARCHAR(20) NOT NULL,
	PRIMARY KEY (CodUsuario)
)
ENGINE = InnoDB
ROW_FORMAT = Compact
CHARACTER SET latin1 COLLATE latin1_swedish_ci;

SET FOREIGN_KEY_CHECKS = 1;


SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS Auditoria
CHARACTER SET latin1;

-- Criação Data_Campo

DROP TABLE IF EXISTS Auditoria.data_campo;
CREATE TABLE Auditoria.data_campo (
	CodCampo INT(10) unsigned NOT NULL AUTO_INCREMENT,
	NmCampo VARCHAR(45) NOT NULL,
	TipoCampo VARCHAR(45) NOT NULL,
	TipoChave VARCHAR(45) NOT NULL,
	Auditar TINYINT(1) NOT NULL DEFAULT '0',
	CodTabela INT(10) unsigned NOT NULL DEFAULT '0',
	SeqCampo INT(10) unsigned NOT NULL DEFAULT '0',
	PRIMARY KEY (CodCampo),
	INDEX CodTabela (CodTabela),
	INDEX CodTabela_2 (CodTabela),
	CONSTRAINT data_campo_ibfk_1 FOREIGN KEY data_campo_ibfk_1 (CodTabela)
		REFERENCES Auditoria.data_tabela (CodTabela)
		ON DELETE RESTRICT
		ON UPDATE RESTRICT
)
ENGINE = InnoDB
ROW_FORMAT = Compact
CHARACTER SET latin1 COLLATE latin1_swedish_ci;

-- Criação Data_tabela

DROP TABLE IF EXISTS Auditoria.data_tabela;
CREATE TABLE Auditoria.data_tabela (
	CodTabela INT(10) unsigned NOT NULL AUTO_INCREMENT,	
	NmTabela VARCHAR(45) NULL,
	NmEsquema VARCHAR(45) NULL,
	TriggerInsert VARCHAR(45) NULL,
	UsaTriggerInsert TINYINT(1) NULL,
	TriggerUpdate VARCHAR(45) NULL,
	UsaTriggerUpdate TINYINT(1) NULL,
	TriggerDelete VARCHAR(45) NULL,
	UsaTriggerDelete TINYINT(1) NULL,
	PRIMARY KEY (CodTabela)
)
ENGINE = InnoDB
ROW_FORMAT = Compact
CHARACTER SET latin1 COLLATE latin1_swedish_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- Povoando tabela Data_tabela

DELIMITER ||
DROP PROCEDURE IF EXISTS Auditoria.SP_Data_tabela;
CREATE DEFINER = 'root'@'localhost' PROCEDURE SP_Data_tabela(in Pschema varchar(45))
begin
	DECLARE PNmTabela VarCHAR(45);
	DECLARE FINAL INT;
	DECLARE CNmTabela CURSOR FOR select distinct table_name from information_schema.columns where
	table_schema=Pschema;
	DECLARE exit HANDLER FOR NOT FOUND SET FINAL=0;
	OPEN CNmTabela;
	REPEAT
	FETCH CNmTabela INTO PNmTabela;
	INSERT INTO Auditoria.Data_tabela
	VALUES(null,PNmTabela,Pschema,concat('Aud_InS_',PNmTabela),false,concat('Aud_Upd_',PNmTabela),false,concat('Aud_Del_',PNmTabela),false);
	until(FINAL=0)
	END REPEAT;
	CLOSE CNmTabela;
	commit;
	
END;||
DELIMITER ;

-- Povoando tabela Data_Campo

DELIMITER ||

DROP PROCEDURE IF EXISTS Auditoria.SP_Data_Campo;
CREATE DEFINER='root'@'localhost' PROCEDURE SP_Data_Campo()
begin
	DECLARE PNmColuna VarCHAR(45);
	DECLARE PNmTipoColuna VarCHAR(45);
	DECLARE PNmTipoChave VarCHAR(45);
	DECLARE PCodTabela int;
	DECLARE PSeqColuna int;
	DECLARE FINAL INT;
	DECLARE CNmColuna CURSOR FOR select C.Column_name,C.data_type,C.column_key,T.CodTabela,C.ordinal_position
	from information_schema.columns C , Auditoria.Data_tabela T where C.table_schema=T.NmEsquema
	and C.Table_name=T.NmTabela order by T.CodTabela,C.ordinal_position;
	DECLARE exit HANDLER FOR NOT FOUND SET FINAL=0;
	OPEN CNmColuna;
	REPEAT
	FETCH CNmColuna INTO PNmColuna,PNmTipoColuna,PNmTipoChave,PCodTabela,PSeqColuna;
	INSERT INTO Auditoria.Data_Campo
	VALUES(null,PNmColuna,PNmTipoColuna,PNmTipoChave,true,PCodTabela,PSeqColuna);
	until(FINAL=0)
END REPEAT;
CLOSE CNmColuna;

END;||
DELIMITER ;

SET FOREIGN_KEY_CHECKS = 0;

-- Criação auditoria

CREATE DATABASE IF NOT EXISTS auditoria
CHARACTER SET latin1;

-- Criação Transação

DROP TABLE IF EXISTS auditoria.transacao;
CREATE TABLE auditoria.transacao (
	T_ID VARCHAR(37) NOT NULL DEFAULT '',
	T_ACAO INT(11) NOT NULL DEFAULT '0',
	T_HOST VARCHAR(15) NOT NULL,
	T_USER_BANCO VARCHAR(30) NOT NULL,
	T_USER_APLICACAO INT(11) NOT NULL DEFAULT '0',
	T_DATA DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
	T_TABELA VARCHAR(45) NOT NULL,
	T_BANCO VARCHAR(45) NOT NULL,
	PRIMARY KEY (T_ID)
)
ENGINE = InnoDB
ROW_FORMAT = Compact
CHARACTER SET latin1 COLLATE latin1_swedish_ci;

-- Criação Transação_data

DROP TABLE IF EXISTS auditoria.transacao_data;
CREATE TABLE auditoria.transacao_data (
	TD_ID VARCHAR(37) NOT NULL DEFAULT '',
	T_ID VARCHAR(37) NOT NULL DEFAULT '',
	TD_CAMPO VARCHAR(45) NOT NULL DEFAULT '',
	TD_CHAVE INT(11) NOT NULL DEFAULT '0',
	TD_OLD_VALOR VARCHAR(255),
	TD_NEW_VALOR VARCHAR(255),
	PRIMARY KEY (TD_ID),
	INDEX T_ID (T_ID),
	CONSTRAINT transacao_data_ibfk_1 FOREIGN KEY transacao_data_ibfk_1 (T_ID)
		REFERENCES auditoria.transacao (T_ID)
		ON DELETE RESTRICT
		ON UPDATE RESTRICT
)
ENGINE = InnoDB
ROW_FORMAT = Compact
CHARACTER SET latin1 COLLATE latin1_swedish_ci;

-- Criação Transação_data_blob

DROP TABLE IF EXISTS auditoria.transacao_data_blob;
CREATE TABLE auditoria.transacao_data_blob (
	TDB_ID VARCHAR(37) NOT NULL DEFAULT '',
	T_ID VARCHAR(37) NOT NULL DEFAULT '',
	TDB_CAMPO VARCHAR(45) NOT NULL DEFAULT '',
	TDB_CHAVE INT(11) NOT NULL DEFAULT '0',
	TDB_OLD_VALOR BLOB,
	TDB_NEW_VALOR BLOB,
	PRIMARY KEY (TDB_ID),
	INDEX T_ID (T_ID),
	CONSTRAINT transacao_data_blob_ibfk_1 FOREIGN KEY transacao_data_blob_ibfk_1 (T_ID)
		REFERENCES auditoria.transacao (T_ID)
		ON DELETE RESTRICT
		ON UPDATE RESTRICT
)
ENGINE = InnoDB
ROW_FORMAT = Compact
CHARACTER SET latin1 COLLATE latin1_swedish_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- Criação TRIGGER Funcionário

DELIMITER ||
	CREATE TRIGGER Aud_Upd_funcionario BEFORE UPDATE ON FolhaPagamento.funcionario
	FOR EACH ROW BEGIN
	
	set @T_ID = UUID();
	
	INSERT INTO auditoria.transacao(T_ID,T_ACAO,T_HOST,T_USER_BANCO,T_USER_APLICACAO,T_DATA,T_TABELA,T_BANCO)
	values(@T_ID,2,@host,user(),@iduser,now(), 'funcionario' , 'FolhaPagamento');
	
	INSERT INTO auditoria.transacao_data
	(TD_ID,T_ID,TD_CAMPO,TD_CHAVE,TD_OLD_VALOR,TD_NEW_VALOR)
	values(UUID(),@T_ID,'CodFuncionario',1,OLD.CodFuncionario,NEW.CodFuncionario);
	
	IF OLD.NmFuncionario <> NEW.NmFuncionario then
	INSERT INTO auditoria.transacao_data
	(TD_ID,T_ID,TD_CAMPO,TD_CHAVE,TD_OLD_VALOR,TD_NEW_VALOR)
	values(UUID(),@T_ID,'NmFuncionario',3,OLD.NmFuncionario,NEW.NmFuncionario);
	end if ;
	
	IF OLD.CodDepartamento <> NEW.CodDepartamento then
	INSERT INTO auditoria.transacao_data
	(TD_ID,T_ID,TD_CAMPO,TD_CHAVE,TD_OLD_VALOR,TD_NEW_VALOR)
	values(UUID(),@T_ID,'CodDepartamento',3,OLD.CodDepartamento,NEW.CodDepartamento);
	end if ;
	
END;||
DELIMITER ;

-- Criação TRIGGER Insere Funcionário

DELIMITER ||
	CREATE TRIGGER Aud_Ins_funcionario BEFORE INSERT ON FolhaPagamento.funcionario
	FOR EACH ROW BEGIN
	
	set @T_ID = UUID();
	
	INSERT INTO auditoria.transacao(T_ID,T_ACAO,T_HOST,T_USER_BANCO,T_USER_APLICACAO,T_DATA,T_TABELA,T_BANCO)
	values(@T_ID,1,@host,user(),@iduser,now(), 'funcionario' , 'FolhaPagamento');
	
	INSERT INTO auditoria.transacao_data
	(TD_ID,T_ID,TD_CAMPO,TD_CHAVE,TD_OLD_VALOR,TD_NEW_VALOR)
	values(UUID(),@T_ID,'CodFuncionario',1,NULL,NEW.CodFuncionario);
	
	INSERT INTO auditoria.transacao_data
	(TD_ID,T_ID,TD_CAMPO,TD_CHAVE,TD_OLD_VALOR,TD_NEW_VALOR)
	values(UUID(),@T_ID,'NmFuncionario',3,NULL,NEW.NmFuncionario);
	
	INSERT INTO auditoria.transacao_data
	(TD_ID,T_ID,TD_CAMPO,TD_CHAVE,TD_OLD_VALOR,TD_NEW_VALOR)
	values(UUID(),@T_ID,'CodDepartamento',3,NULL,NEW.CodDepartamento);
	
END;||
DELIMITER ;

-- Criação TRIGGER Registra exclusão Funcionário

DELIMITER ||
	CREATE TRIGGER Aud_Del_funcionario BEFORE DELETE ON FolhaPagamento.funcionario
	FOR EACH ROW BEGIN
	
	set @T_ID = UUID();
	
	INSERT INTO auditoria.transacao(T_ID,T_ACAO,T_HOST,T_USER_BANCO,T_USER_APLICACAO,T_DATA,T_TABELA,T_BANCO)
	values(@T_ID,3,@host,user(),@iduser,now(), 'funcionario' , 'FolhaPagamento');
	
	INSERT INTO auditoria.transacao_data
	(TD_ID,T_ID,TD_CAMPO,TD_CHAVE,TD_OLD_VALOR,TD_NEW_VALOR)
	values(UUID(),@T_ID,'CodFuncionario',1,OLD.CodFuncionario,NULL);

	INSERT INTO auditoria.transacao_data
	(TD_ID,T_ID,TD_CAMPO,TD_CHAVE,TD_OLD_VALOR,TD_NEW_VALOR)
	values(UUID(),@T_ID,'NmFuncionario',3,OLD.NmFuncionario,NULL);
	
	INSERT INTO auditoria.transacao_data
	(TD_ID,T_ID,TD_CAMPO,TD_CHAVE,TD_OLD_VALOR,TD_NEW_VALOR)
	values(UUID(),@T_ID,'CodDepartamento',3,OLD.CodDepartamento,NULL);
	
END;||
DELIMITER ;

SET @Iduser=1;
SET @Host='192.168.1.112'

INSERT INTO FolhaPagamento.departamento values(1, 'Depto.Computacao');
INSERT INTO FolhaPagamento.usuario values(1, 'Administrador', 'aluno', 'aluno');
INSERT INTO FolhaPagamento.funcionario values(1, 'JOAO', 1);
	SELECT*FROM auditoria.transacao;
	SELECT*FROM auditoria.transacao_data;
	SELECT L.NmUsuario, T.T_Data, T.T_Tabela, D.Td_campo, D.Td_New_valor
		FROM auditoria.transacao as T, auditoria.transacao_data as D, FolhaPagamento.Usuario as L
			WHERE T.T_Id=D.T_Id and T.T_User_Aplicacao=L.CodUsuario and T.T_acao=1;

UPDATE funcionario set nmfuncionario='Joao Paulo';
		SELECT*FROM auditoria.transacao;
		SELECT*FROM auditoria.transacao_data;
		SELECT L.NmUsuario, T.T_Data, T.T_Tabela, D.Td_Campo, D.Td_Old_valor, D.Td_New_valor 
			FROM auditoria.transacao as T, auditoria.transacao_data as D, FolhaPagamento.Usuario as L
				WHERE T.T_Id=D.T_Id and T.T_User_Aplicacao=L.CodUsuario and T.T_acao=2;

DELETE FROM funcionario;
	SELECT*FROM auditoria.transacao;
	SELECT*FROM auditoria.transacao_data;
	SELECT L.NmUsuario, T.T_Data, T.T_Tabela, D.Td_campo, D.Td_Old_valor
		FROM auditoria.transacao as T, auditoria.transacao_data as D, FolhaPagamento.Usuario as L
			WHERE T.T_Id=D.T_Id and T.T_User_Aplicacao=L.CodUsuario and T.T_acao=3;
