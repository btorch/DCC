-- MySQL Script generated by MySQL Workbench
-- Thu Sep 19 14:01:04 2019
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema base_dados2
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema base_dados2
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `base_dados2` DEFAULT CHARACTER SET utf8 ;
USE `base_dados2` ;

-- -----------------------------------------------------
-- Table `base_dados2`.`pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `base_dados2`.`pedido` (
  `id` BIGINT(20) UNSIGNED NOT NULL,
  `Data` VARCHAR(20) NOT NULL,
  `Dta_Lanc` DATETIME NOT NULL,
  `Codcli` MEDIUMINT(10) UNSIGNED NOT NULL,
  `CodVen` SMALLINT(5) UNSIGNED NOT NULL,
  `Formpgto` VARCHAR(5) NOT NULL,
  `CondPgto` TINYINT(3) UNSIGNED NOT NULL,
  `TotPed` DOUBLE(9,2) UNSIGNED NOT NULL,
  `Obs` VARCHAR(150) NULL,
  `Critica` VARCHAR(150) NULL,
  `Status` VARCHAR(5) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `base_dados2`.`prdped`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `base_dados2`.`prdped` (
  `Id` BIGINT(20) UNSIGNED NOT NULL,
  `Data` VARCHAR(20) NOT NULL,
  `Codcli` MEDIUMINT(10) UNSIGNED NOT NULL,
  `CodVen` SMALLINT(5) UNSIGNED NOT NULL,
  `Cdpro` MEDIUMINT(10) UNSIGNED NOT NULL,
  `Descricao` VARCHAR(150) NOT NULL,
  `Und` VARCHAR(5) NULL,
  `Qtd` TINYINT(3) UNSIGNED NOT NULL,
  `Prunit` DOUBLE(9,2) NOT NULL,
  `Desconto` DOUBLE(9,2) NULL,
  `Total` DOUBLE(9,2) NOT NULL,
  `Status` VARCHAR(5) NOT NULL,
  INDEX `Id_idx` (`Id`),
  CONSTRAINT `Id`
    FOREIGN KEY (`Id`)
    REFERENCES `base_dados2`.`pedido` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
