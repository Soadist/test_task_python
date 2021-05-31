-- Dump created by MySQL pump utility, version: 8.0.25, Win64 (x86_64)
-- Dump start time: Mon May 31 11:52:27 2021
-- Server version: 8.0.25

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE;
SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET @@SESSION.SQL_LOG_BIN= 0;
SET @OLD_TIME_ZONE=@@TIME_ZONE;
SET TIME_ZONE='+00:00';
SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET NAMES utf8mb4;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `task_1` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
CREATE TABLE `task_1`.`address` (
`id` int unsigned NOT NULL AUTO_INCREMENT,
`address` varchar(45) NOT NULL,
`entrances` int unsigned NOT NULL DEFAULT '1',
`floors` int unsigned NOT NULL DEFAULT '1',
`quarters` int unsigned NOT NULL DEFAULT '1',
`campus` int unsigned DEFAULT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Address list'
;
CREATE TABLE `task_1`.`campus` (
`id` int unsigned NOT NULL AUTO_INCREMENT,
`object_name` varchar(45) NOT NULL,
`mn` int unsigned DEFAULT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Campus list'
;
CREATE TABLE `task_1`.`chs` (
`id` int unsigned NOT NULL AUTO_INCREMENT,
`address` varchar(45) NOT NULL,
`object_name` varchar(45) NOT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='CHS list'
;
CREATE TABLE `task_1`.`history` (
`id` int unsigned NOT NULL AUTO_INCREMENT,
`object_type` enum('chs','mn','campus','address') NOT NULL,
`operation` enum('insert','update','delete') NOT NULL,
`object_id` int unsigned NOT NULL,
`changes` text,
`date` date NOT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;
CREATE TABLE `task_1`.`mn` (
`id` int unsigned NOT NULL AUTO_INCREMENT,
`object_name` varchar(45) NOT NULL,
`chs` int unsigned DEFAULT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='backbone network list'
;
DELIMITER //
CREATE FUNCTION `task_1`.`address_update`(id INT UNSIGNED,
address VARCHAR(45),
entrances INT UNSIGNED,
floors INT UNSIGNED,
quarters INT UNSIGNED,
campus INT UNSIGNED) RETURNS int
BEGIN

DECLARE
prev_address,
next_campus_object_name
VARCHAR(45);

DECLARE
prev_entr,
prev_floors,
prev_quarters,
prev_campus 
INT UNSIGNED;

IF id IS NULL OR
address IS NULL OR
entrances IS NULL OR
floors IS NULL OR
quarters IS NULL OR
entrances = 0 OR
floors = 0 OR
quarters = 0 OR
campus = 0
THEN
	RETURN -1;
END IF;

IF campus IS NOT NULL THEN
	SELECT `campus`.`object_name`
    INTO next_campus_object_name
    FROM `task_1`.`campus`
    WHERE `id` = campus;
END IF;

SELECT `address`.`address`,
    `address`.`entrances`,
    `address`.`floors`,
    `address`.`quarters`,
    `address`.`campus`
INTO prev_address,
	prev_entr,
	prev_floors,
	prev_quarters,
	prev_campus
FROM `task_1`.`address`
WHERE `address`.`id` = id;

IF prev_address IS NOT NULL AND
(next_campus_object_name IS NOT NULL OR campus IS NULL) AND
(
	prev_address != address OR
	prev_entr != entrances OR
	prev_floors != floors OR
	prev_quarters != quarters OR
	(NOT(prev_campus IS NULL AND campus IS NULL) AND
    prev_campus != campus)
)
THEN
	UPDATE `task_1`.`address`
	SET
	`address` = address,
	`entrances` = entrances,
	`floors` = floors,
	`quarters` = quarters,
	`campus` = campus
	WHERE `id` = id;
	RETURN 1;
ELSE
	RETURN -1;
END IF;

END//
DELIMITER ;
;
DELIMITER //
CREATE FUNCTION `task_1`.`campus_update`(
id INT UNSIGNED,
object_name VARCHAR(45),
mn INT UNSIGNED) RETURNS int
BEGIN

DECLARE 
prev_object_name,
next_mn_object_name VARCHAR(45);

DECLARE
prev_mn INT UNSIGNED;

IF id IS NULL OR
object_name IS NULL OR
id = 0 OR
mn = 0
THEN
	RETURN -1;
END IF;

IF mn IS NOT NULL THEN
	SELECT `mn`.`object_name`
    INTO next_mn_object_name
	FROM `task_1`.`mn`
    WHERE `id` = mn;
END IF;

SELECT `campus`.`object_name`,
`campus`.`mn`
INTO prev_object_name,
prev_mn
FROM `task_1`.`campus`
WHERE `id` = id;

IF prev_object_name IS NOT NULL AND
(next_mn_object_name IS NOT NULL OR mn IS NULL) AND
(
	prev_object_name != object_name OR
    (NOT(prev_mn IS NULL AND mn IS NULL)
    AND prev_mn != mn)
)
THEN
	UPDATE `task_1`.`campus`
	SET
	`object_name` = object_name,
	`mn` = mn
	WHERE `id` = id;
	RETURN 1;
ELSE
	RETURN -1;
END IF;
END//
DELIMITER ;
;
DELIMITER //
CREATE FUNCTION `task_1`.`chs_update`(
id INT UNSIGNED,
address VARCHAR(45),
object_name VARCHAR(45)) RETURNS int
BEGIN

DECLARE prev_address, prev_object_name VARCHAR(45);

IF id IS NULL OR
address IS NULL OR
object_name IS NULL OR
id = 0
THEN
	RETURN -1;
END IF;

SELECT `chs`.`address`, `chs`.`object_name`
INTO prev_address, prev_object_name
FROM `task_1`.`chs`
WHERE `id` = id;

IF prev_address IS NOT NULL AND    
(
prev_address != address OR
prev_object_name != object_name
)
THEN
	UPDATE `task_1`.`chs`
	SET
	`address` = address,
	`object_name` = object_name
	WHERE `id` = id;
	RETURN 1;
ELSE
	RETURN -1;

END IF;

END//
DELIMITER ;
;
DELIMITER //
CREATE PROCEDURE `task_1`.`add_history_record`(IN object_type ENUM('chs','mn','campus','address'),
IN operation ENUM('insert','update','delete'),
IN object_id INT UNSIGNED,
IN changes TEXT)
BEGIN
INSERT INTO `task_1`.`history`
(`id`,
`object_type`,
`operation`,
`object_id`,
`changes`,
`date`)
VALUES
(0,
object_type,
operation,
object_id,
changes,
CURDATE());

END//
DELIMITER ;
;
DELIMITER //
CREATE FUNCTION `task_1`.`mn_update`(
id INT UNSIGNED,
object_name VARCHAR(45),
chs INT UNSIGNED) RETURNS int
BEGIN

DECLARE 
prev_object_name,
next_chs_object_name VARCHAR(45);

DECLARE
prev_chs INT UNSIGNED;

IF id IS NULL OR
object_name IS NULL OR
id = 0 OR
chs = 0
THEN
	RETURN -1;
END IF;

SELECT
    `mn`.`object_name`,
    `mn`.`chs`
INTO prev_object_name, prev_chs
FROM `task_1`.`mn`
WHERE `id` = id;

IF chs IS NOT NULL THEN
	SELECT `chs`.`object_name` INTO next_chs_object_name
	FROM `task_1`.`chs`
	WHERE `id` = chs;
END IF;

IF(prev_object_name IS NOT NULL) AND
(next_chs_object_name IS NOT NULL OR chs IS NULL) AND
(
	prev_object_name != object_name OR
	(NOT(prev_chs IS NULL AND chs is NULL) AND
    prev_chs != chs)
)
THEN
	UPDATE `task_1`.`mn`
	SET
	`object_name` = object_name,
	`chs` = chs
	WHERE `id` = id;
	RETURN 1;
ELSE
	RETURN -1;
END IF;

END//
DELIMITER ;
;
USE `task_1`;
ALTER TABLE `task_1`.`address` ADD UNIQUE KEY `address_UNIQUE` (`address`);
ALTER TABLE `task_1`.`address` ADD UNIQUE KEY `id_UNIQUE` (`id`);
ALTER TABLE `task_1`.`address` ADD KEY `campus.id_idx` (`campus`);
ALTER TABLE `task_1`.`address` ADD CONSTRAINT `campus.id` FOREIGN KEY (`campus`) REFERENCES `campus` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
DELIMITER //
/*!50017 CREATE*/  /*!50017 TRIGGER `task_1`.`address_AFTER_INSERT` AFTER INSERT ON `address` FOR EACH ROW BEGIN
CALL `task_1`.`add_history_record`
('address',
'insert',
new.id,
CONCAT('address=',
new.address,
', floors=',
new.floors,
', quarters=',
new.quarters,
', campus=',
COALESCE(new.campus, 'NULL')));
END */
//
DELIMITER ;
;
DELIMITER //
/*!50017 CREATE*/  /*!50017 TRIGGER `task_1`.`address_AFTER_UPDATE` AFTER UPDATE ON `address` FOR EACH ROW BEGIN
CALL `task_1`.`add_history_record`
('address',
'update',
old.id,
CONCAT('address=',
old.address,
'->',
new.address,
', floors=',
old.floors,
'->',
new.floors,
', quarters=',
old.quarters,
'->',
new.quarters,
', campus=',
COALESCE(old.campus, 'NULL'),
'->',
COALESCE(new.campus, 'NULL')));
END */
//
DELIMITER ;
;
DELIMITER //
/*!50017 CREATE*/  /*!50017 TRIGGER `task_1`.`address_AFTER_DELETE` AFTER DELETE ON `address` FOR EACH ROW BEGIN
CALL `task_1`.`add_history_record`
('address',
'delete',
old.id,
null);
END */
//
DELIMITER ;
;
USE `task_1`;
ALTER TABLE `task_1`.`campus` ADD UNIQUE KEY `name_UNIQUE` (`object_name`);
ALTER TABLE `task_1`.`campus` ADD KEY `mn.id_idx` (`mn`);
ALTER TABLE `task_1`.`campus` ADD CONSTRAINT `mn.id` FOREIGN KEY (`mn`) REFERENCES `mn` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
DELIMITER //
/*!50017 CREATE*/  /*!50017 TRIGGER `task_1`.`campus_AFTER_INSERT` AFTER INSERT ON `campus` FOR EACH ROW BEGIN
CALL `task_1`.`add_history_record`
('campus',
'insert',
new.id,
CONCAT(
'object_name=',
new.object_name,
', mn=',
COALESCE(new.mn, 'NULL')
));
END */
//
DELIMITER ;
;
DELIMITER //
/*!50017 CREATE*/  /*!50017 TRIGGER `task_1`.`campus_AFTER_UPDATE` AFTER UPDATE ON `campus` FOR EACH ROW BEGIN
CALL `task_1`.`add_history_record`
('campus',
'update',
old.id,
CONCAT('object_name=',
old.object_name,
'->',
new.object_name,
', mn=',
COALESCE(old.mn, 'NULL'),
'->',
COALESCE(new.mn, 'NULL')));
END */
//
DELIMITER ;
;
DELIMITER //
/*!50017 CREATE*/  /*!50017 TRIGGER `task_1`.`campus_AFTER_DELETE` AFTER DELETE ON `campus` FOR EACH ROW BEGIN
CALL `task_1`.`add_history_record`
('campus',
'delete',
old.id,
null);
END */
//
DELIMITER ;
;
USE `task_1`;
ALTER TABLE `task_1`.`chs` ADD UNIQUE KEY `name_UNIQUE` (`object_name`);
DELIMITER //
/*!50017 CREATE*/  /*!50017 TRIGGER `task_1`.`chs_AFTER_INSERT` AFTER INSERT ON `chs` FOR EACH ROW BEGIN
CALL `task_1`.`add_history_record`
('chs',
'insert',
new.id,
CONCAT(
'object_name=',
new.object_name,
', address=',
new.address));
END */
//
DELIMITER ;
;
DELIMITER //
/*!50017 CREATE*/  /*!50017 TRIGGER `task_1`.`chs_AFTER_UPDATE` AFTER UPDATE ON `chs` FOR EACH ROW BEGIN
CALL `task_1`.`add_history_record`
('chs',
'update',
old.id,
CONCAT('object_name=',
old.object_name,
'->',
new.object_name,
', address=',
old.address,
'->',
new.address));
END */
//
DELIMITER ;
;
DELIMITER //
/*!50017 CREATE*/  /*!50017 TRIGGER `task_1`.`chs_AFTER_DELETE` AFTER DELETE ON `chs` FOR EACH ROW BEGIN
CALL `task_1`.`add_history_record`
('chs',
'delete',
old.id,
null);
END */
//
DELIMITER ;
;
USE `task_1`;
ALTER TABLE `task_1`.`history` ADD UNIQUE KEY `id_UNIQUE` (`id`);
DELIMITER //
/*!50017 CREATE*/  /*!50017 TRIGGER `task_1`.`mn_AFTER_INSERT` AFTER INSERT ON `mn` FOR EACH ROW BEGIN
CALL `task_1`.`add_history_record`
('mn',
'insert',
new.id,
CONCAT(
'object_name=',
new.object_name,
', chs=',
COALESCE(new.chs, 'NULL')
));
END */
//
DELIMITER ;
;
USE `task_1`;
ALTER TABLE `task_1`.`mn` ADD KEY `chs.id_idx` (`chs`);
ALTER TABLE `task_1`.`mn` ADD CONSTRAINT `chs.id` FOREIGN KEY (`chs`) REFERENCES `chs` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
DELIMITER //
/*!50017 CREATE*/  /*!50017 TRIGGER `task_1`.`mn_AFTER_UPDATE` AFTER UPDATE ON `mn` FOR EACH ROW BEGIN
CALL `task_1`.`add_history_record`
('mn',
'update',
old.id,
CONCAT('object_name=',
old.object_name,
'->',
new.object_name,
', chs=',
COALESCE(old.chs, 'NULL'),
'->',
COALESCE(new.chs, 'NULL')));
END */
//
DELIMITER ;
;
DELIMITER //
/*!50017 CREATE*/  /*!50017 TRIGGER `task_1`.`mn_AFTER_DELETE` AFTER DELETE ON `mn` FOR EACH ROW BEGIN
CALL `task_1`.`add_history_record`
('mn',
'delete',
old.id,
null);
END */
//
DELIMITER ;
;
SET TIME_ZONE=@OLD_TIME_ZONE;
SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT;
SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS;
SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
SET SQL_MODE=@OLD_SQL_MODE;
-- Dump end time: Mon May 31 11:52:28 2021
