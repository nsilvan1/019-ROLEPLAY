-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.4.20-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para vrp
CREATE DATABASE IF NOT EXISTS `vrp` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `vrp`;

-- Copiando estrutura para tabela vrp.groups_control
CREATE TABLE IF NOT EXISTS `groups_control` (
  `name` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `num_members` int(11) DEFAULT NULL,
  `money` int(11) DEFAULT NULL,
  `roles` varchar(255) DEFAULT NULL,
  `max_members` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Copiando dados para a tabela vrp.groups_control: ~17 rows (aproximadamente)
/*!40000 ALTER TABLE `groups_control` DISABLE KEYS */;
INSERT INTO `groups_control` (`name`, `type`, `num_members`, `money`, `roles`, `max_members`) VALUES
	('Policia', 'LEGAL', 20, 0, '{"PolMaster","Police","waitPolice"}', 15),
	('Admin', 'STAFF', 11, 0, '{"Owner","Admin"}', 30),
	('Laranja', 'ILEGAL', 0, 0, '{"LaranjaMaster","Laranja"}', 30),
	('Fazenda', 'ILEGAL', 7, 2280, '{"FazendaMaster","Fazenda"}', 15),
	('Paramedico', 'LEGAL', 10, 0, '{"ParMaster","waitParamedic","Paramedic"}', 15),
	('Cartel', 'ILEGAL', 11, 0, '{"CartelMaster","Cartel"}', 15),
	('Roxo', 'ILEGAL', 10, 0, '{"RoxoMaster","Roxo"}', 15),
	('Amarelo', 'ILEGAL', 10, 0, '{"AmareloMaster","Amarelo"}', 15),
	('Azul', 'ILEGAL', 10, 0, '{"AzulMaster","Azul"}', 15),
	('Mafia', 'ILEGAL', 1, 0, '{"MafiaMaster","Mafia"}', 15),
	('Vanilla', 'ILEGAL', 10, 0, '{"VanillaMaster","Vanilla"}', 15),
	('Vermelho', 'ILEGAL', 5, 161, '{"VermelhoMaster","Vermelho"}', 15),
	('Verde', 'ILEGAL', 8, 0, '{"VerdeMaster","Verde"}', 15),
	('Bahama', 'ILEGAL', 1, 0, '{"BahamaMaster","Bahama"}', 15),
	('Motoclub', 'ILEGAL', 10, 70, '{"MotoclubMaster","Motoclub"}', 15),
	('LSC', 'LEGAL', 10, 0, '{"LSCMaster","LSC"}', 15),
	('Bennys', 'LEGAL', 10, 0, '{"BennysMaster","Bennys"}', 15);
/*!40000 ALTER TABLE `groups_control` ENABLE KEYS */;

-- Copiando estrutura para tabela vrp.groups_donates
CREATE TABLE IF NOT EXISTS `groups_donates` (
  `user_id` int(11) NOT NULL,
  `groupname` varchar(50) DEFAULT NULL,
  `donate` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Copiando dados para a tabela vrp.groups_donates: ~5 rows (aproximadamente)
/*!40000 ALTER TABLE `groups_donates` DISABLE KEYS */;
INSERT INTO `groups_donates` (`user_id`, `groupname`, `donate`) VALUES
	(34, 'Fazenda', 780),
	(41, 'Fazenda', 500),
	(149, 'Fazenda', 510),
	(423, 'Motoclub', 60);
/*!40000 ALTER TABLE `groups_donates` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
