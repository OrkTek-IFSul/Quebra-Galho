-- MySQL Script generated by MySQL Workbench
-- Thu Apr 17 23:55:28 2025
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema quebragalhodb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema quebragalhodb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `quebragalhodb` DEFAULT CHARACTER SET utf8 ;
USE `quebragalhodb` ;

-- -----------------------------------------------------
-- Table `quebragalhodb`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`usuario` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(60) NOT NULL,
  `email` VARCHAR(60) NOT NULL,
  `senha` VARCHAR(45) NOT NULL,
  `documento` VARCHAR(45) NOT NULL,
  `telefone` VARCHAR(45) NOT NULL,
  `num_strike` INT NOT NULL,
  `img_perfil` VARCHAR(100) NULL,
  `token` VARCHAR(100) NULL,
  `is_admin` TINYINT NOT NULL,
  `is_moderador` TINYINT NOT NULL,
  PRIMARY KEY (`id_usuario`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quebragalhodb`.`prestador`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`prestador` (
  `id_prestador` INT NOT NULL AUTO_INCREMENT,
  `descricao_prestador` VARCHAR(200) NOT NULL,
  `documento_path` VARCHAR(100) NOT NULL,
  `id_usuario_fk` INT NOT NULL,
  PRIMARY KEY (`id_prestador`),
  INDEX `fk_prestador_usuario_idx` (`id_usuario_fk` ASC),
  CONSTRAINT `fk_prestador_usuario`
    FOREIGN KEY (`id_usuario_fk`)
    REFERENCES `quebragalhodb`.`usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quebragalhodb`.`chat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`chat` (
  `id_chat` INT NOT NULL AUTO_INCREMENT,
  `mensagens` VARCHAR(200) NOT NULL,
  `data` DATE NOT NULL,
  `id_prestador_fk` INT NOT NULL,
  `id_usuario_fk` INT NOT NULL,
  PRIMARY KEY (`id_chat`),
  INDEX `fk_chat_prestador1_idx` (`id_prestador_fk` ASC),
  INDEX `fk_chat_usuario1_idx` (`id_usuario_fk` ASC),
  CONSTRAINT `fk_chat_prestador1`
    FOREIGN KEY (`id_prestador_fk`)
    REFERENCES `quebragalhodb`.`prestador` (`id_prestador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_chat_usuario1`
    FOREIGN KEY (`id_usuario_fk`)
    REFERENCES `quebragalhodb`.`usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quebragalhodb`.`tag`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`tag` (
  `id_tag` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `status` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_tag`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quebragalhodb`.`servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`servico` (
  `id_servico` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(45) NOT NULL,
  `preco` DOUBLE NOT NULL,
  `id_prestador_fk` INT NOT NULL,
  PRIMARY KEY (`id_servico`),
  INDEX `fk_servico_prestador1_idx` (`id_prestador_fk` ASC),
  CONSTRAINT `fk_servico_prestador1`
    FOREIGN KEY (`id_prestador_fk`)
    REFERENCES `quebragalhodb`.`prestador` (`id_prestador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quebragalhodb`.`portfolio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`portfolio` (
  `id_portfolio` INT NOT NULL AUTO_INCREMENT,
  `img_porfolio_path` VARCHAR(45) NOT NULL,
  `id_prestador_fk` INT NOT NULL,
  PRIMARY KEY (`id_portfolio`),
  INDEX `fk_portfolio_prestador1_idx` (`id_prestador_fk` ASC),
  CONSTRAINT `fk_portfolio_prestador1`
    FOREIGN KEY (`id_prestador_fk`)
    REFERENCES `quebragalhodb`.`prestador` (`id_prestador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quebragalhodb`.`agendamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`agendamento` (
  `id_agendamento` INT NOT NULL AUTO_INCREMENT,
  `data_hora` DATETIME NOT NULL,
  `status` TINYINT NOT NULL,
  `id_servico_fk` INT NOT NULL,
  `id_usuario_fk` INT NOT NULL,
  PRIMARY KEY (`id_agendamento`),
  INDEX `fk_agendamento_servico1_idx` (`id_servico_fk` ASC),
  INDEX `fk_agendamento_usuario1_idx` (`id_usuario_fk` ASC),
  CONSTRAINT `fk_agendamento_servico1`
    FOREIGN KEY (`id_servico_fk`)
    REFERENCES `quebragalhodb`.`servico` (`id_servico`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_agendamento_usuario1`
    FOREIGN KEY (`id_usuario_fk`)
    REFERENCES `quebragalhodb`.`usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quebragalhodb`.`avaliacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`avaliacao` (
  `id_avaliacao` INT NOT NULL AUTO_INCREMENT,
  `nota` INT NOT NULL,
  `comentario` VARCHAR(200) NOT NULL,
  `data` DATE NOT NULL,
  `id_agendamento_fk` INT NOT NULL,
  PRIMARY KEY (`id_avaliacao`),
  INDEX `fk_avaliacao_agendamento1_idx` (`id_agendamento_fk` ASC),
  CONSTRAINT `fk_avaliacao_agendamento1`
    FOREIGN KEY (`id_agendamento_fk`)
    REFERENCES `quebragalhodb`.`agendamento` (`id_agendamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quebragalhodb`.`resposta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`resposta` (
  `id_resposta` INT NOT NULL AUTO_INCREMENT,
  `comentario_resposta` VARCHAR(100) NOT NULL,
  `data` DATE NOT NULL,
  `id_avaliacao_fk` INT NOT NULL,
  PRIMARY KEY (`id_resposta`),
  INDEX `fk_resposta_avaliacao1_idx` (`id_avaliacao_fk` ASC),
  CONSTRAINT `fk_resposta_avaliacao1`
    FOREIGN KEY (`id_avaliacao_fk`)
    REFERENCES `quebragalhodb`.`avaliacao` (`id_avaliacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quebragalhodb`.`denuncia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`denuncia` (
  `id_denuncia` INT NOT NULL AUTO_INCREMENT,
  `tipo` VARCHAR(45) NOT NULL,
  `motivo` VARCHAR(100) NOT NULL,
  `status` TINYINT NOT NULL,
  `id_comentario` INT NULL,
  `id_denunciante` INT NOT NULL,
  `id_denunciado` INT NOT NULL,
  PRIMARY KEY (`id_denuncia`),
  INDEX `fk_denuncia_usuario1_idx` (`id_denunciante` ASC),
  INDEX `fk_denuncia_usuario2_idx` (`id_denunciado` ASC),
  CONSTRAINT `fk_denuncia_usuario1`
    FOREIGN KEY (`id_denunciante`)
    REFERENCES `quebragalhodb`.`usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_denuncia_usuario2`
    FOREIGN KEY (`id_denunciado`)
    REFERENCES `quebragalhodb`.`usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quebragalhodb`.`apelo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`apelo` (
  `id_apelo` INT NOT NULL AUTO_INCREMENT,
  `justificativa` VARCHAR(50) NOT NULL,
  `status` TINYINT NOT NULL,
  `id_denuncia_fk` INT NOT NULL,
  PRIMARY KEY (`id_apelo`),
  INDEX `fk_apelo_denuncia1_idx` (`id_denuncia_fk` ASC),
  CONSTRAINT `fk_apelo_denuncia1`
    FOREIGN KEY (`id_denuncia_fk`)
    REFERENCES `quebragalhodb`.`denuncia` (`id_denuncia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quebragalhodb`.`tag_prestador`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`tag_prestador` (
  `id_tag_fk` INT NOT NULL,
  `id_prestador_fk` INT NOT NULL,
  PRIMARY KEY (`id_tag_fk`, `id_prestador_fk`),
  INDEX `fk_tag_has_prestador_prestador1_idx` (`id_prestador_fk` ASC),
  INDEX `fk_tag_has_prestador_tag1_idx` (`id_tag_fk` ASC),
  CONSTRAINT `fk_tag_has_prestador_tag1`
    FOREIGN KEY (`id_tag_fk`)
    REFERENCES `quebragalhodb`.`tag` (`id_tag`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tag_has_prestador_prestador1`
    FOREIGN KEY (`id_prestador_fk`)
    REFERENCES `quebragalhodb`.`prestador` (`id_prestador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quebragalhodb`.`tag_servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quebragalhodb`.`tag_servico` (
  `id_tag_fk` INT NOT NULL,
  `id_servico_fk` INT NOT NULL,
  PRIMARY KEY (`id_tag_fk`, `id_servico_fk`),
  INDEX `fk_tag_has_servico_servico1_idx` (`id_servico_fk` ASC),
  INDEX `fk_tag_has_servico_tag1_idx` (`id_tag_fk` ASC),
  CONSTRAINT `fk_tag_has_servico_tag1`
    FOREIGN KEY (`id_tag_fk`)
    REFERENCES `quebragalhodb`.`tag` (`id_tag`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tag_has_servico_servico1`
    FOREIGN KEY (`id_servico_fk`)
    REFERENCES `quebragalhodb`.`servico` (`id_servico`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
