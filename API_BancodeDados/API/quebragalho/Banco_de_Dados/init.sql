
-- -----------------------------------------------------
-- Schema quebragalhodb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema quebragalhodb - CHARSET CORRIGIDO
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `quebragalhodb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `quebragalhodb`;

-- Logo após USE quebragalhodb;
SET
  NAMES utf8mb4;

SET
  CHARACTER SET utf8mb4;

-- -----------------------------------------------------
-- Table `quebragalhodb`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`usuario` (
  `id_usuario` BIGINT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(60) NOT NULL,
  `email` VARCHAR(60) NOT NULL,
  `senha` VARCHAR(255) NOT NULL,
  `documento` VARCHAR(45) NOT NULL,
  `telefone` VARCHAR(45) NOT NULL,
  `num_strike` INT NOT NULL,
  `img_perfil` VARCHAR(100) NULL,
  `token` VARCHAR(100) NULL,
  `is_admin` BIT NOT NULL,
  `is_moderador` BIT NOT NULL,
  `is_ativo` BIT NOT NULL,
  PRIMARY KEY (`id_usuario`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `quebragalhodb`.`prestador`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`prestador` (
  `id_prestador` BIGINT NOT NULL AUTO_INCREMENT,
  `descricao_prestador` VARCHAR(200) NOT NULL,
  `documento_path` VARCHAR(100) NOT NULL,
  `data_hora_inicio` DATETIME NULL,
  `data_hora_fim` DATETIME NULL,
  `aceito` BIT NULL,
  `id_usuario_fk` BIGINT NOT NULL,
  PRIMARY KEY (`id_prestador`),
  INDEX `fk_prestador_usuario_idx` (`id_usuario_fk` ASC),
  CONSTRAINT `fk_prestador_usuario` FOREIGN KEY (`id_usuario_fk`) REFERENCES `quebragalhodb`.`usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `quebragalhodb`.`chat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`chat` (
  `id_chat` BIGINT NOT NULL AUTO_INCREMENT,
  `mensagens` VARCHAR(200) NOT NULL,
  `data` DATE NOT NULL,
  `id_prestador_fk` BIGINT NOT NULL,
  `id_usuario_fk` BIGINT NOT NULL,
  PRIMARY KEY (`id_chat`),
  INDEX `fk_chat_prestador1_idx` (`id_prestador_fk` ASC),
  INDEX `fk_chat_usuario1_idx` (`id_usuario_fk` ASC),
  CONSTRAINT `fk_chat_prestador1` FOREIGN KEY (`id_prestador_fk`) REFERENCES `quebragalhodb`.`prestador` (`id_prestador`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_chat_usuario1` FOREIGN KEY (`id_usuario_fk`) REFERENCES `quebragalhodb`.`usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `quebragalhodb`.`tag`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`tag` (
  `id_tag` BIGINT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `status` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_tag`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `quebragalhodb`.`servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`servico` (
  `id_servico` BIGINT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(45) NOT NULL,
  `preco` DOUBLE NOT NULL,
  `ativo` BIT NOT NULL,
  `duracao_minutos` INT NOT NULL;
  `id_prestador_fk` BIGINT NOT NULL,
  PRIMARY KEY (`id_servico`),
  INDEX `fk_servico_prestador1_idx` (`id_prestador_fk` ASC),
  CONSTRAINT `fk_servico_prestador1` FOREIGN KEY (`id_prestador_fk`) REFERENCES `quebragalhodb`.`prestador` (`id_prestador`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `quebragalhodb`.`portfolio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`portfolio` (
  `id_portfolio` BIGINT NOT NULL AUTO_INCREMENT,
  `img_porfolio_path` VARCHAR(45) NOT NULL,
  `id_prestador_fk` BIGINT NOT NULL,
  PRIMARY KEY (`id_portfolio`),
  INDEX `fk_portfolio_prestador1_idx` (`id_prestador_fk` ASC),
  CONSTRAINT `fk_portfolio_prestador1` FOREIGN KEY (`id_prestador_fk`) REFERENCES `quebragalhodb`.`prestador` (`id_prestador`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `quebragalhodb`.`agendamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`agendamento` (
  `id_agendamento` BIGINT NOT NULL AUTO_INCREMENT,
  `data_hora` DATETIME NOT NULL,
  `status` BIT NOT NULL,
  `status_aceito` BIT NULL,
  `id_servico_fk` BIGINT NOT NULL,
  `id_usuario_fk` BIGINT NOT NULL,
  PRIMARY KEY (`id_agendamento`),
  INDEX `fk_agendamento_servico_idx` (`id_servico_fk` ASC),
  INDEX `fk_agendamento_usuario1_idx` (`id_usuario_fk` ASC),
  CONSTRAINT `fk_agendamento_servico` FOREIGN KEY (`id_servico_fk`) REFERENCES `quebragalhodb`.`servico` (`id_servico`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_agendamento_usuario` FOREIGN KEY (`id_usuario_fk`) REFERENCES `quebragalhodb`.`usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `quebragalhodb`.`avaliacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`avaliacao` (
  `id_avaliacao` BIGINT NOT NULL AUTO_INCREMENT,
  `nota` INT NOT NULL,
  `comentario` VARCHAR(200) NOT NULL,
  `data` DATE NOT NULL,
  `id_agendamento_fk` BIGINT NOT NULL,
  PRIMARY KEY (`id_avaliacao`),
  INDEX `fk_avaliacao_agendamento_idx` (`id_agendamento_fk` ASC),
  CONSTRAINT `fk_avaliacao_agendamento` FOREIGN KEY (`id_agendamento_fk`) REFERENCES `quebragalhodb`.`agendamento` (`id_agendamento`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `quebragalhodb`.`resposta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`resposta` (
  `id_resposta` BIGINT NOT NULL AUTO_INCREMENT,
  `comentario_resposta` VARCHAR(100) NOT NULL,
  `data` DATE NOT NULL,
  `id_avaliacao_fk` BIGINT NOT NULL,
  PRIMARY KEY (`id_resposta`),
  INDEX `fk_resposta_avaliacao1_idx` (`id_avaliacao_fk` ASC),
  CONSTRAINT `fk_resposta_avaliacao1` FOREIGN KEY (`id_avaliacao_fk`) REFERENCES `quebragalhodb`.`avaliacao` (`id_avaliacao`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `quebragalhodb`.`denuncia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`denuncia` (
  `id_denuncia` BIGINT NOT NULL AUTO_INCREMENT,
  `tipo` VARCHAR(45) NOT NULL,
  `motivo` VARCHAR(100) NOT NULL,
  `status` BIT NOT NULL,
  `id_comentario` BIGINT NULL,
  `id_denunciante` BIGINT NOT NULL,
  `id_denunciado` BIGINT NOT NULL,
  PRIMARY KEY (`id_denuncia`),
  INDEX `fk_denuncia_usuario1_idx` (`id_denunciante` ASC),
  INDEX `fk_denuncia_usuario2_idx` (`id_denunciado` ASC),
  CONSTRAINT `fk_denuncia_usuario1` FOREIGN KEY (`id_denunciante`) REFERENCES `quebragalhodb`.`usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_denuncia_usuario2` FOREIGN KEY (`id_denunciado`) REFERENCES `quebragalhodb`.`usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `quebragalhodb`.`apelo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`apelo` (
  `id_apelo` BIGINT NOT NULL AUTO_INCREMENT,
  `justificativa` VARCHAR(100) NOT NULL,
  `status` BIT NOT NULL,
  `id_denuncia_fk` BIGINT NOT NULL,
  PRIMARY KEY (`id_apelo`),
  INDEX `fk_apelo_denuncia1_idx` (`id_denuncia_fk` ASC),
  CONSTRAINT `fk_apelo_denuncia1` FOREIGN KEY (`id_denuncia_fk`) REFERENCES `quebragalhodb`.`denuncia` (`id_denuncia`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `quebragalhodb`.`tag_prestador`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`tag_prestador` (
  `id_tag_fk` BIGINT NOT NULL,
  `id_prestador_fk` BIGINT NOT NULL,
  PRIMARY KEY (`id_tag_fk`, `id_prestador_fk`),
  INDEX `fk_tag_has_prestador_prestador1_idx` (`id_prestador_fk` ASC),
  INDEX `fk_tag_has_prestador_tag1_idx` (`id_tag_fk` ASC),
  CONSTRAINT `fk_tag_has_prestador_tag1` FOREIGN KEY (`id_tag_fk`) REFERENCES `quebragalhodb`.`tag` (`id_tag`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_tag_has_prestador_prestador1` FOREIGN KEY (`id_prestador_fk`) REFERENCES `quebragalhodb`.`prestador` (`id_prestador`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `quebragalhodb`.`tag_servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`tag_servico` (
  `id_tag_fk` BIGINT NOT NULL,
  `id_servico_fk` BIGINT NOT NULL,
  PRIMARY KEY (`id_tag_fk`, `id_servico_fk`),
  INDEX `fk_tag_has_servico_servico1_idx` (`id_servico_fk` ASC),
  INDEX `fk_tag_has_servico_tag1_idx` (`id_tag_fk` ASC),
  CONSTRAINT `fk_tag_has_servico_tag1` FOREIGN KEY (`id_tag_fk`) REFERENCES `quebragalhodb`.`tag` (`id_tag`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_tag_has_servico_servico1` FOREIGN KEY (`id_servico_fk`) REFERENCES `quebragalhodb`.`servico` (`id_servico`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

SET
  SQL_MODE = @OLD_SQL_MODE;

SET
  FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;

SET
  UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS;

ALTER DATABASE quebragalhodb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ALTERAR CHARSET DAS TABELAS EXISTENTES POR GARANTIA
ALTER TABLE
  usuario CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE
  prestador CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE
  chat CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE
  tag CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE
  servico CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE
  portfolio CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE
  agendamento CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE
  avaliacao CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE
  resposta CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE
  denuncia CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE
  apelo CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE
  tag_prestador CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE
  tag_servico CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- =============================================
-- TAGS (15 categorias de serviços)
-- =============================================
INSERT INTO `tag` (`id_tag`, `nome`, `status`)
VALUES
  (1, 'Elétrica', 'ativo'),
  (2, 'Hidráulica', 'ativo'),
  (3, 'Informática', 'ativo'),
  (4, 'Pintura', 'ativo'),
  (5, 'Marcenaria', 'ativo'),
  (6, 'Jardinagem', 'ativo'),
  (7, 'Mecânica', 'ativo'),
  (8, 'Chaveiro', 'ativo'),
  (9, 'Dedetização', 'ativo'),
  (10, 'Montagem', 'ativo'),
  (11, 'Reforma', 'ativo'),
  (12, 'Limpeza', 'ativo'),
  (13, 'Encanamento', 'ativo'),
  (14, 'Instalação', 'ativo'),
  (15, 'Manutenção', 'ativo');