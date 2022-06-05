CREATE DATABASE IF NOT EXISTS `framework`;
USE `framework`;

CREATE TABLE `users` (
	`citizenid` VARCHAR(50) NOT NULL,
	`identifier` VARCHAR(255) NOT NULL,	
	`name` VARCHAR(255) NOT NULL,	
	`group` VARCHAR(50) NULL DEFAULT 'user',	
	`job` TEXT NOT NULL,
	`gang` TEXT DEFAULT NULL,
	`accounts` LONGTEXT NULL DEFAULT NULL,
	`inventory` LONGTEXT NULL DEFAULT '{}',
	`position` VARCHAR(255) NOT NULL,
	`firstname` varchar(16) DEFAULT NULL,
  	`lastname` varchar(16) DEFAULT NULL,
  	`dateofbirth` varchar(10) DEFAULT NULL,
  	`sex` varchar(1) DEFAULT NULL,
  	`height` int(11) DEFAULT NULL,
	`metadata` TEXT NULL DEFAULT NULL,
	`skin` LONGTEXT DEFAULT NULL,
	`phone_number` VARCHAR(20) DEFAULT NULL,
	`is_dead` tinyint(1) DEFAULT 0,
	`last_updated` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
	PRIMARY KEY (`citizenid`),
	KEY `identifier` (`identifier`),
	KEY `last_updated` (`last_updated`)
) ENGINE=InnoDB;

CREATE TABLE `jobs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  `whitelisted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB;

CREATE TABLE `job_grades` (
  `job_name` varchar(50) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `is_boss` tinyint(1) DEFAULT 0,
  `salary` int(11) NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `gangs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB;

CREATE TABLE `gang_grades` (
  `gang_name` varchar(50) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `is_boss` tinyint(1) DEFAULT 0,
  `salary` int(11) NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `items` (
	`name` VARCHAR(50) NOT NULL,
	`label` VARCHAR(50) NOT NULL,
	`weight` INT NOT NULL DEFAULT 1,
	`rare` TINYINT NOT NULL DEFAULT 0,
	`can_remove` TINYINT NOT NULL DEFAULT 1,
	PRIMARY KEY (`name`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `bans` (
	`identifier` VARCHAR(255) NOT NULL,
	`name` varchar(255) DEFAULT NULL,
	`liveid` varchar(50) DEFAULT NULL,
	`xblid` varchar(50) DEFAULT NULL,
	`discord` varchar(50) DEFAULT NULL,
	`ip` varchar(50) DEFAULT NULL,
	`reason` text DEFAULT NULL,
	`expire` int(11) DEFAULT NULL,
	`bannedby` varchar(255) NOT NULL DEFAULT 'Framework',
	PRIMARY KEY (`identifier`),
	KEY `liveid` (`liveid`),
	KEY `xblid` (`xblid`),
	KEY `discord` (`discord`),
	KEY `ip` (`ip`)
) ENGINE=InnoDB AUTO_INCREMENT=1;

INSERT INTO `jobs` VALUES ('unemployed', 'Unemployed', 0);
INSERT INTO `job_grades` VALUES (1, 'unemployed', 0, 'unemployed', 'Unemployed', 0, 200, '{}', '{}');

INSERT INTO `gangs` VALUES ('nogang', 'NoGang');
INSERT INTO `gang_grades` VALUES (1, 'nogang', 0, 'nogang', 'NoGang', 0, 0, '{}', '{}');