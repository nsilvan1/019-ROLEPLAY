CREATE TABLE `vehicle_cloned` (
	`user_id` INT(11) NULL DEFAULT NULL,
	`vehicle` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`dataInicio` DATETIME NULL DEFAULT current_timestamp(),
	`dataFim` DATETIME NULL DEFAULT NULL
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;


CREATE TABLE `vehicle_cloned_solicit` (
	`user_id` INT(11) NULL DEFAULT NULL,
	`vehicle` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`dataInicio` DATETIME NULL DEFAULT current_timestamp(),
	`dataCloned` DATETIME NULL DEFAULT current_timestamp(),
	`dataFim` DATETIME NULL DEFAULT current_timestamp()
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;