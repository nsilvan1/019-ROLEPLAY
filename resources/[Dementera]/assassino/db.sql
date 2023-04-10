-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.4.27-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.4.0.6659
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para elite
CREATE DATABASE IF NOT EXISTS `thunder` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `thunder`;

-- Copiando estrutura para view elite.elite_assassino
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `elite_assassino` (
	`elite_assassino_id` INT(11) NOT NULL,
	`name` VARCHAR(50) NULL COLLATE 'latin1_swedish_ci',
	`firstname` VARCHAR(50) NULL COLLATE 'latin1_swedish_ci',
	`phone` VARCHAR(20) NULL COLLATE 'latin1_swedish_ci',
	`ativo` VARCHAR(1) NULL COLLATE 'utf8mb4_general_ci',
	`user_id` INT(11) NOT NULL,
	`hierarquia_id` INT(11) NOT NULL,
	`hierarquia_nome` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`permite_alterar` VARCHAR(1) NULL COLLATE 'utf8mb4_general_ci'
) ENGINE=MyISAM;

-- Copiando estrutura para tabela elite.elite_assassino_hierarquia
CREATE TABLE IF NOT EXISTS `elite_assassino_hierarquia` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL DEFAULT '0',
  `altera` varchar(1) DEFAULT 'N',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela elite.elite_assassino_hierarquia: ~7 rows (aproximadamente)
INSERT INTO `elite_assassino_hierarquia` (`id`, `nome`, `altera`) VALUES
	(1, 'Lider do Grupo', 'S'),
	(2, 'Gerente dos caçadores', 'N'),
	(3, 'caçadores de Recompensa sênior', 'N'),
	(4, 'Caçador de Recompensa Junior', 'N'),
	(5, 'Caçador de recompensa Pleno', 'N'),
	(6, 'Estagiário', 'N');

-- Copiando estrutura para tabela elite.elite_assassino_user
CREATE TABLE IF NOT EXISTS `elite_assassino_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `ativo` varchar(1) DEFAULT 'S',
  `hierarquia_id` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela elite.elite_assassino_user: ~2 rows (aproximadamente)
INSERT INTO `elite_assassino_user` (`id`, `user_id`, `ativo`, `hierarquia_id`) VALUES
	(1, 2, 'S', 1);

-- Copiando estrutura para tabela elite.elite_cprocurado
CREATE TABLE IF NOT EXISTS `elite_cprocurado` (
  `procurado_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `firstname` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `name` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `recompensa` double DEFAULT NULL,
  PRIMARY KEY (`procurado_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela elite.elite_cprocurado: 0 rows
/*!40000 ALTER TABLE `elite_cprocurado` DISABLE KEYS */;
/*!40000 ALTER TABLE `elite_cprocurado` ENABLE KEYS */;

-- Copiando estrutura para view elite.elite_assassino
-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `elite_assassino`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `elite_assassino` AS SELECT c.id AS elite_assassino_id,
       vui.name ,
       vui.firstname ,
       vui.phone ,
       c.ativo,
       c.user_id,
       ch.id AS hierarquia_id, 
       ch.nome AS hierarquia_nome,
		 ch.altera AS permite_alterar      
 FROM elite_assassino_user c
INNER JOIN vrp_user_identities vui
ON c.user_id = vui.user_id 
INNER JOIN elite_assassino_hierarquia ch
ON ch.id = c.hierarquia_id ;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
