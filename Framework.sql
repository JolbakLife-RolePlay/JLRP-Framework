CREATE DATABASE IF NOT EXISTS `Framework`;
USE `Framework`;

ALTER DATABASE `Framework`
	DEFAULT CHARACTER SET UTF8MB4;
	
ALTER DATABASE `Framework`
	DEFAULT COLLATE UTF8MB4_UNICODE_CI;

CREATE TABLE `users` (
	`citizenid` VARCHAR(50) NOT NULL,
	`identifier` VARCHAR(255) NOT NULL,	
	`name` VARCHAR(255) NOT NULL,	
	`group` VARCHAR(50) NULL DEFAULT 'user',	
	`job` TEXT NOT NULL,
	`gang` TEXT DEFAULT NULL,
	`accounts` LONGTEXT NULL DEFAULT NULL,
	`inventory` LONGTEXT NULL DEFAULT NULL,
	`loadout` LONGTEXT NULL DEFAULT NULL,
	`position` VARCHAR(255) NOT NULL,
	`firstname` varchar(16) DEFAULT NULL,
  	`lastname` varchar(16) DEFAULT NULL,
  	`dateofbirth` varchar(10) DEFAULT NULL,
  	`sex` varchar(1) DEFAULT NULL,
  	`height` int(11) DEFAULT NULL,
	`charinfo` TEXT DEFAULT NULL,
	`metadata` TEXT NULL DEFAULT NULL,
	`skin` LONGTEXT DEFAULT NULL,
	`is_dead` tinyint(1) DEFAULT 0,
	`last_updated` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
	PRIMARY KEY (`citizenid`),
	KEY `identifier` (`identifier`),
	KEY `last_updated` (`last_updated`),
) ENGINE=InnoDB;

CREATE TABLE `jobs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  `whitelisted` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE `job_grades` (
  `id` int(11) NOT NULL,
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
  `whitelisted` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE `gang_grades` (
  `id` int(11) NOT NULL,
  `gang_name` varchar(50) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `is_boss` tinyint(1) DEFAULT 0,
  `salary` int(11) NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL
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