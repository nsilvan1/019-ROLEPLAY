-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.4.24-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.0.0.6468
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para basedados
CREATE DATABASE IF NOT EXISTS `basedados` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `basedados`;

-- Copiando estrutura para tabela basedados.cacador_hierarquia
CREATE TABLE IF NOT EXISTS `cacador_hierarquia` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL DEFAULT '0',
  `altera` varchar(1) DEFAULT 'N',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

-- Copiando dados para a tabela basedados.cacador_hierarquia: ~5 rows (aproximadamente)
INSERT INTO `cacador_hierarquia` (`id`, `nome`, `altera`) VALUES
	(1, 'Lider d Grupo', 'S'),
	(2, 'Gerente dos caçadores', 'N'),
	(3, 'caçadores de Recompensa sênior', 'N'),
	(4, 'Caçador de Recompensa Junior', 'N'),
	(5, 'Caçador de recompensa Pleno', 'N');

-- Copiando estrutura para tabela basedados.cacador_user
CREATE TABLE IF NOT EXISTS `cacador_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `ativo` varchar(1) DEFAULT 'S',
  `hierarquia_id` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4;

-- Copiando dados para a tabela basedados.cacador_user: ~4 rows (aproximadamente)
INSERT INTO `cacador_user` (`id`, `user_id`, `ativo`, `hierarquia_id`) VALUES
	(15, 1, 'S', 1),
	(17, 10, 'S', 3),
	(18, 4, 'S', 4),
	(19, 2, 'S', 4);

-- Copiando estrutura para tabela basedados.tbl_policia_procurado
CREATE TABLE IF NOT EXISTS `tbl_policia_procurado` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `recompensa` double DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4;

-- Copiando dados para a tabela basedados.tbl_policia_procurado: ~1 rows (aproximadamente)

-- Copiando estrutura para view basedados.vw_cacador
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `vw_cacador` (
	`cacador_id` INT(11) NOT NULL,
	`name` VARCHAR(50) NULL COLLATE 'latin1_swedish_ci',
	`phone` VARCHAR(20) NULL COLLATE 'latin1_swedish_ci',
	`ativo` VARCHAR(1) NULL COLLATE 'utf8mb4_general_ci',
	`user_id` INT(11) NOT NULL,
	`hierarquia_id` INT(11) NOT NULL,
	`hierarquia_nome` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`permite_alterar` VARCHAR(1) NULL COLLATE 'utf8mb4_general_ci'
) ENGINE=MyISAM;

-- Copiando estrutura para view basedados.vw_procurado
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `vw_procurado` (
	`procurado_id` INT(11) NULL,
	`user_id` INT(11) NOT NULL,
	`firstname` VARCHAR(50) NULL COLLATE 'latin1_swedish_ci',
	`name` VARCHAR(50) NULL COLLATE 'latin1_swedish_ci',
	`recompensa` DOUBLE NULL
) ENGINE=MyISAM;

-- Copiando estrutura para view basedados.vw_cacador
-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `vw_cacador`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_cacador` AS SELECT c.id AS cacador_id,
       vui.name ,
       vui.phone ,
       c.ativo,
       c.user_id,
       ch.id AS hierarquia_id, 
       ch.nome AS hierarquia_nome,
		 ch.altera AS permite_alterar      
 FROM cacador_user c
INNER JOIN vrp_user_identities vui
ON c.user_id = vui.user_id 
INNER JOIN cacador_hierarquia ch
ON ch.id = c.hierarquia_id ;

-- Copiando estrutura para view basedados.vw_procurado
-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `vw_procurado`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_procurado` AS SELECT tpp.id as procurado_id, vui.user_id, vui.firstname, vui.name, tpp.recompensa FROM vrp_user_identities vui
left JOIN tbl_policia_procurado  tpp
ON vui.user_id = tpp.user_id
WHERE vui.foragido = 1 OR tpp.id IS NOT NULL ;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
