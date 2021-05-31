-- Dump created by MySQL pump utility, version: 8.0.25, Win64 (x86_64)
-- Dump start time: Mon May 31 12:41:03 2021
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
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Address list'
;
CREATE TABLE `task_1`.`campus` (
`id` int unsigned NOT NULL AUTO_INCREMENT,
`object_name` varchar(45) NOT NULL,
`mn` int unsigned DEFAULT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Campus list'
;
CREATE TABLE `task_1`.`chs` (
`id` int unsigned NOT NULL AUTO_INCREMENT,
`address` varchar(45) NOT NULL,
`object_name` varchar(45) NOT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='CHS list'
;
CREATE TABLE `task_1`.`history` (
`id` int unsigned NOT NULL AUTO_INCREMENT,
`object_type` enum('chs','mn','campus','address') NOT NULL,
`operation` enum('insert','update','delete') NOT NULL,
`object_id` int unsigned NOT NULL,
`changes` text,
`date` date NOT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;
INSERT INTO `task_1`.`address` VALUES (1,"Nevsky 100",1,2,4,1),(2,"Nevsky 101",1,2,4,1),(3,"Nevsky 102",1,2,4,1),(4,"Nevsky 103",1,2,4,1),(5,"Nevsky 200",1,2,4,2),(6,"Nevsky 201",1,2,4,2),(7,"Nevsky 202",1,2,4,2),(8,"Nevsky 203",1,2,4,2),(9,"Nevsky 300",1,2,4,3),(10,"Nevsky 301",1,2,4,3),(11,"Nevsky 302",1,2,4,3),(12,"Nevsky 303",1,2,4,3),(13,"Nevsky 400",1,2,4,4),(14,"Nevsky 401",1,2,4,4),(15,"Nevsky 402",1,2,4,4),(16,"Nevsky 403",1,2,4,4),(17,"Nevsky 500",1,2,4,5),(18,"Nevsky 501",1,2,4,5),(19,"Nevsky 502",1,2,4,5),(20,"Nevsky 503",1,2,4,5),(21,"Nevsky 600",1,2,4,6),(22,"Nevsky 601",1,2,4,6),(23,"Nevsky 602",1,2,4,6),(24,"Nevsky 603",1,2,4,6),(25,"Nevsky 700",1,2,4,7),(26,"Nevsky 701",1,2,4,7),(27,"Nevsky 702",1,2,4,7),(28,"Nevsky 703",1,2,4,7),(29,"Nevsky 800",1,2,4,8),(30,"Nevsky 801",1,2,4,8),(31,"Nevsky 802",1,2,4,8),(32,"Nevsky 803",1,2,4,8),(33,"Nevsky 900",1,2,4,9),(34,"Nevsky 901",1,2,4,9),(35,"Nevsky 902",1,2,4,9),(36,"Nevsky 903",1,2,4,9),(37,"Nevsky 000",1,2,4,10),(38,"Nevsky 001",1,2,4,10),(39,"Nevsky 002",1,2,4,10),(40,"Nevsky 003",1,2,4,10),(41,"Nevsky 110",1,2,4,11),(42,"Nevsky 111",1,2,4,11),(43,"Nevsky 112",1,2,4,11),(44,"Nevsky 113",1,2,4,11),(45,"Nevsky 120",1,2,4,12),(46,"Nevsky 121",1,2,4,12),(47,"Nevsky 122",1,2,4,12),(48,"Nevsky 123",1,2,4,12);
CREATE TABLE `task_1`.`mn` (
`id` int unsigned NOT NULL AUTO_INCREMENT,
`object_name` varchar(45) NOT NULL,
`chs` int unsigned DEFAULT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='backbone network list'
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
CREATE PROCEDURE `task_1`.`add_history_record`(IN object_type ENUM('chs','mn','campus','address'),
IN operation ENUM('insert','update','delete'),
IN object_id INT UNSIGNED,
IN changes TEXT)
BEGIN
INSERT INTO `task_1`.`history`
(`object_type`,
`operation`,
`object_id`,
`changes`,
`date`)
VALUES
(object_type,
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
INSERT INTO `task_1`.`chs` VALUES (1,"Nevsky, 100","CHS 1"),(2,"Zanevsky, 100","CHS 2"),(3,"Zanevsky, 200","CHS 3"),(5,"Central, 5","CHS 5"),(6,"Nevsky, 200","CHS 4");
INSERT INTO `task_1`.`campus` VALUES (1,"Campus 201",1),(2,"Campus 202",1),(3,"Campus 501",3),(4,"Campus 502",3),(5,"Campus 101",5),(6,"Campus 102",5),(7,"Campus x01",6),(8,"Campus x02",2),(9,"Campus 301",2),(10,"Campus 302",2),(11,"Campus x03",2),(12,"Campus x04",2);
USE `task_1`;
ALTER TABLE `task_1`.`address` ADD UNIQUE KEY `address_UNIQUE` (`address`);
ALTER TABLE `task_1`.`address` ADD UNIQUE KEY `id_UNIQUE` (`id`);
ALTER TABLE `task_1`.`address` ADD KEY `campus.id_idx` (`campus`);
ALTER TABLE `task_1`.`address` ADD CONSTRAINT `campus.id` FOREIGN KEY (`campus`) REFERENCES `campus` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
INSERT INTO `task_1`.`history` VALUES (1,"chs","insert",1,"object_name=CHS 1, address=Nevsky, 100","2017-05-30"),(2,"chs","insert",2,"object_name=CHS 2, address=Zanevsky, 100","2017-05-30"),(3,"chs","insert",3,"object_name=CHS 3, address=Zanevsky, 200","2017-05-30"),(4,"chs","insert",4,"object_name=CHS 4, address=Nevsky, 200","2017-05-30"),(5,"chs","insert",5,"object_name=CHS 5, address=Central, 5","2017-05-30"),(6,"chs","delete",4,'',"2017-05-30"),(7,"chs","insert",6,"object_name=CHS 4, address=Nevsky, 200","2017-05-30"),(8,"mn","insert",1,"object_name=MN 1, chs=2","2017-05-30"),(9,"mn","insert",2,"object_name=MN 2, chs=3","2017-05-30"),(10,"mn","insert",3,"object_name=MN 3, chs=5","2017-05-30"),(11,"mn","insert",4,"object_name=MN 4, chs=6","2017-05-30"),(12,"mn","insert",5,"object_name=MN 5, chs=1","2017-05-30"),(13,"mn","delete",4,'',"2017-05-30"),(14,"mn","insert",6,"object_name=MN 4, chs=NULL","2017-05-30"),(15,"campus","insert",1,"object_name=Campus 201, mn=1","2017-05-30"),(16,"campus","insert",2,"object_name=Campus 202, mn=1","2017-05-30"),(17,"campus","insert",3,"object_name=Campus 501, mn=3","2017-05-30"),(18,"campus","insert",4,"object_name=Campus 502, mn=3","2017-05-30"),(19,"campus","insert",5,"object_name=Campus 101, mn=5","2017-05-30"),(20,"campus","insert",6,"object_name=Campus 102, mn=5","2017-05-30"),(21,"campus","insert",7,"object_name=Campus x01, mn=6","2017-05-30"),(22,"campus","insert",8,"object_name=Campus x02, mn=NULL","2017-05-30"),(23,"campus","insert",9,"object_name=Campus 301, mn=2","2017-05-30"),(24,"campus","insert",10,"object_name=Campus 302, mn=2","2017-05-30"),(25,"campus","insert",11,"object_name=Campus x03, mn=NULL","2017-05-30"),(26,"campus","insert",12,"object_name=Campus x04, mn=NULL","2017-05-30"),(27,"address","insert",1,"address=Nevsky 100, floors=2, quarters=4, campus=1","2018-05-30"),(28,"address","insert",2,"address=Nevsky 101, floors=2, quarters=4, campus=1","2018-05-30"),(29,"address","delete",2,'',"2018-05-30"),(30,"address","insert",3,"address=Nevsky 102, floors=2, quarters=4, campus=1","2019-06-01"),(31,"address","insert",4,"address=Nevsky 103, floors=2, quarters=4, campus=1","2019-06-20"),(32,"address","insert",5,"address=Nevsky 200, floors=2, quarters=4, campus=2","2019-07-20"),(33,"address","delete",4,'',"2019-07-20"),(34,"address","insert",6,"address=Nevsky 201, floors=2, quarters=4, campus=2","2019-07-30"),(35,"address","insert",7,"address=Nevsky 202, floors=2, quarters=4, campus=2","2019-08-01"),(36,"address","insert",8,"address=Nevsky 203, floors=2, quarters=4, campus=2","2019-08-10"),(37,"address","insert",9,"address=Nevsky 300, floors=2, quarters=4, campus=3","2019-09-20"),(38,"address","insert",10,"address=Nevsky 301, floors=2, quarters=4, campus=3","2019-09-30"),(39,"address","insert",11,"address=Nevsky 302, floors=2, quarters=4, campus=3","2019-10-01"),(40,"address","delete",8,'',"2019-10-01"),(41,"address","delete",6,'',"2019-10-10"),(42,"address","insert",12,"address=Nevsky 303, floors=2, quarters=4, campus=3","2019-10-10"),(43,"address","insert",13,"address=Nevsky 400, floors=2, quarters=4, campus=4","2019-11-20"),(44,"address","insert",14,"address=Nevsky 401, floors=2, quarters=4, campus=4","2019-12-30"),(45,"address","insert",15,"address=Nevsky 402, floors=2, quarters=4, campus=4","2020-01-01"),(46,"address","insert",16,"address=Nevsky 403, floors=2, quarters=4, campus=4","2020-02-10"),(47,"address","insert",17,"address=Nevsky 500, floors=2, quarters=4, campus=5","2020-03-20"),(48,"address","insert",18,"address=Nevsky 501, floors=2, quarters=4, campus=5","2020-03-30"),(49,"address","insert",19,"address=Nevsky 502, floors=2, quarters=4, campus=5","2020-04-01"),(50,"address","insert",20,"address=Nevsky 503, floors=2, quarters=4, campus=5","2020-04-10"),(51,"address","insert",21,"address=Nevsky 600, floors=2, quarters=4, campus=6","2020-05-20"),(52,"address","delete",15,'',"2020-05-20"),(53,"address","delete",17,'',"2020-05-20"),(54,"address","insert",22,"address=Nevsky 601, floors=2, quarters=4, campus=6","2020-05-20"),(55,"address","insert",23,"address=Nevsky 602, floors=2, quarters=4, campus=6","2020-06-10"),(56,"address","insert",24,"address=Nevsky 603, floors=2, quarters=4, campus=6","2020-06-20"),(57,"address","insert",25,"address=Nevsky 700, floors=2, quarters=4, campus=7","2020-07-25"),(58,"address","insert",26,"address=Nevsky 701, floors=2, quarters=4, campus=7","2020-07-30"),(59,"address","delete",19,'',"2020-07-30"),(60,"address","insert",27,"address=Nevsky 702, floors=2, quarters=4, campus=7","2020-08-10"),(61,"address","delete",14,'',"2020-08-20"),(62,"address","insert",28,"address=Nevsky 703, floors=2, quarters=4, campus=7","2020-08-20"),(63,"address","delete",12,'',"2020-08-20"),(64,"address","insert",29,"address=Nevsky 800, floors=2, quarters=4, campus=8","2020-09-10"),(65,"address","insert",30,"address=Nevsky 801, floors=2, quarters=4, campus=8","2020-09-15"),(66,"address","insert",31,"address=Nevsky 802, floors=2, quarters=4, campus=8","2020-10-05"),(67,"address","insert",32,"address=Nevsky 803, floors=2, quarters=4, campus=8","2020-10-25"),(68,"address","insert",33,"address=Nevsky 900, floors=2, quarters=4, campus=9","2020-11-27"),(69,"address","insert",34,"address=Nevsky 901, floors=2, quarters=4, campus=9","2020-12-25"),(70,"address","insert",35,"address=Nevsky 902, floors=2, quarters=4, campus=9","2021-01-10"),(71,"address","insert",36,"address=Nevsky 903, floors=2, quarters=4, campus=9","2021-01-20"),(72,"address","insert",37,"address=Nevsky 000, floors=2, quarters=4, campus=10","2021-01-30"),(73,"address","insert",38,"address=Nevsky 001, floors=2, quarters=4, campus=10","2021-01-30"),(74,"address","insert",39,"address=Nevsky 002, floors=2, quarters=4, campus=10","2021-02-11"),(75,"address","insert",40,"address=Nevsky 003, floors=2, quarters=4, campus=10","2021-02-17"),(76,"address","insert",41,"address=Nevsky 110, floors=2, quarters=4, campus=11","2021-03-20"),(77,"address","insert",42,"address=Nevsky 111, floors=2, quarters=4, campus=11","2021-03-25"),(78,"address","insert",43,"address=Nevsky 112, floors=2, quarters=4, campus=11","2021-03-26"),(79,"address","insert",44,"address=Nevsky 113, floors=2, quarters=4, campus=11","2021-04-08"),(80,"address","insert",45,"address=Nevsky 120, floors=2, quarters=4, campus=12","2021-04-16"),(81,"address","insert",46,"address=Nevsky 121, floors=2, quarters=4, campus=12","2021-04-19"),(82,"address","insert",47,"address=Nevsky 122, floors=2, quarters=4, campus=12","2021-04-24"),(83,"address","insert",48,"address=Nevsky 123, floors=2, quarters=4, campus=12","2021-04-29"),(84,"address","insert",49,"address=Nevsky x00, floors=2, quarters=4, campus=NULL","2021-05-01"),(85,"address","delete",1,'',"2021-05-01"),(86,"address","delete",7,'',"2021-05-02"),(87,"address","delete",35,'',"2021-05-02"),(88,"address","insert",50,"address=Nevsky x01, floors=2, quarters=4, campus=NULL","2021-05-02"),(89,"address","insert",51,"address=Nevsky x02, floors=2, quarters=4, campus=NULL","2021-05-03"),(90,"address","insert",52,"address=Nevsky x03, floors=2, quarters=4, campus=NULL","2021-05-04"),(91,"address","insert",53,"address=Nevsky x10, floors=2, quarters=4, campus=NULL","2021-05-05"),(92,"address","insert",54,"address=Nevsky x11, floors=2, quarters=4, campus=NULL","2021-05-06"),(93,"address","insert",55,"address=Nevsky x12, floors=2, quarters=4, campus=NULL","2021-05-07"),(94,"address","insert",56,"address=Nevsky x13, floors=2, quarters=4, campus=NULL","2021-05-08"),(95,"address","insert",57,"address=Nevsky x20, floors=2, quarters=4, campus=NULL","2021-05-09"),(96,"address","insert",58,"address=Nevsky x21, floors=2, quarters=4, campus=NULL","2021-05-10"),(97,"address","delete",34,'',"2021-05-10"),(98,"address","insert",59,"address=Nevsky x22, floors=2, quarters=4, campus=NULL","2021-05-11"),(99,"address","insert",60,"address=Nevsky x23, floors=2, quarters=4, campus=NULL","2021-05-15");
DELIMITER //
/*!50017 CREATE*/ /*!50003 DEFINER=`root`@`localhost`*/ /*!50017 TRIGGER `task_1`.`address_AFTER_INSERT` AFTER INSERT ON `address` FOR EACH ROW BEGIN
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
/*!50017 CREATE*/ /*!50003 DEFINER=`root`@`localhost`*/ /*!50017 TRIGGER `task_1`.`address_AFTER_UPDATE` AFTER UPDATE ON `address` FOR EACH ROW BEGIN
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
/*!50017 CREATE*/ /*!50003 DEFINER=`root`@`localhost`*/ /*!50017 TRIGGER `task_1`.`address_AFTER_DELETE` AFTER DELETE ON `address` FOR EACH ROW BEGIN
CALL `task_1`.`add_history_record`
('address',
'delete',
old.id,
null);
END */
//
DELIMITER ;
;
INSERT INTO `task_1`.`mn` VALUES (1,"MN 1",2),(2,"MN 2",3),(3,"MN 3",5),(5,"MN 5",1),(6,"MN 4",NULL);
USE `task_1`;
ALTER TABLE `task_1`.`chs` ADD UNIQUE KEY `name_UNIQUE` (`object_name`);
DELIMITER //
/*!50017 CREATE*/ /*!50003 DEFINER=`root`@`localhost`*/ /*!50017 TRIGGER `task_1`.`chs_AFTER_INSERT` AFTER INSERT ON `chs` FOR EACH ROW BEGIN
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
/*!50017 CREATE*/ /*!50003 DEFINER=`root`@`localhost`*/ /*!50017 TRIGGER `task_1`.`chs_AFTER_UPDATE` AFTER UPDATE ON `chs` FOR EACH ROW BEGIN
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
/*!50017 CREATE*/ /*!50003 DEFINER=`root`@`localhost`*/ /*!50017 TRIGGER `task_1`.`chs_AFTER_DELETE` AFTER DELETE ON `chs` FOR EACH ROW BEGIN
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
ALTER TABLE `task_1`.`campus` ADD UNIQUE KEY `name_UNIQUE` (`object_name`);
ALTER TABLE `task_1`.`campus` ADD KEY `mn.id_idx` (`mn`);
ALTER TABLE `task_1`.`campus` ADD CONSTRAINT `mn.id` FOREIGN KEY (`mn`) REFERENCES `mn` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
DELIMITER //
/*!50017 CREATE*/ /*!50003 DEFINER=`root`@`localhost`*/ /*!50017 TRIGGER `task_1`.`campus_AFTER_INSERT` AFTER INSERT ON `campus` FOR EACH ROW BEGIN
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
/*!50017 CREATE*/ /*!50003 DEFINER=`root`@`localhost`*/ /*!50017 TRIGGER `task_1`.`campus_AFTER_UPDATE` AFTER UPDATE ON `campus` FOR EACH ROW BEGIN
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
/*!50017 CREATE*/ /*!50003 DEFINER=`root`@`localhost`*/ /*!50017 TRIGGER `task_1`.`campus_AFTER_DELETE` AFTER DELETE ON `campus` FOR EACH ROW BEGIN
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
ALTER TABLE `task_1`.`history` ADD UNIQUE KEY `id_UNIQUE` (`id`);
USE `task_1`;
DELIMITER //
/*!50017 CREATE*/ /*!50003 DEFINER=`root`@`localhost`*/ /*!50017 TRIGGER `task_1`.`mn_AFTER_INSERT` AFTER INSERT ON `mn` FOR EACH ROW BEGIN
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
ALTER TABLE `task_1`.`mn` ADD KEY `chs.id_idx` (`chs`);
ALTER TABLE `task_1`.`mn` ADD CONSTRAINT `chs.id` FOREIGN KEY (`chs`) REFERENCES `chs` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
DELIMITER //
/*!50017 CREATE*/ /*!50003 DEFINER=`root`@`localhost`*/ /*!50017 TRIGGER `task_1`.`mn_AFTER_UPDATE` AFTER UPDATE ON `mn` FOR EACH ROW BEGIN
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
/*!50017 CREATE*/ /*!50003 DEFINER=`root`@`localhost`*/ /*!50017 TRIGGER `task_1`.`mn_AFTER_DELETE` AFTER DELETE ON `mn` FOR EACH ROW BEGIN
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
-- Dump end time: Mon May 31 12:41:03 2021
