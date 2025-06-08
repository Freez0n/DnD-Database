CREATE DATABASE  IF NOT EXISTS `dnd` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `dnd`;
-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: dnd
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `attribute`
--

DROP TABLE IF EXISTS `attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attribute` (
  `idCharacter` int NOT NULL,
  `Strength` tinyint NOT NULL,
  `Dexterity` tinyint NOT NULL,
  `Constitution` tinyint NOT NULL,
  `Intelligence` tinyint NOT NULL,
  `Wisdom` tinyint NOT NULL,
  `Charisma` tinyint NOT NULL,
  PRIMARY KEY (`idCharacter`),
  KEY `fk_Attribute_Character1_idx` (`idCharacter`),
  CONSTRAINT `fk_Attribute_Character1` FOREIGN KEY (`idCharacter`) REFERENCES `character` (`idCharacter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attribute`
--

LOCK TABLES `attribute` WRITE;
/*!40000 ALTER TABLE `attribute` DISABLE KEYS */;
/*!40000 ALTER TABLE `attribute` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_UpdateInitiative` AFTER INSERT ON `attribute` FOR EACH ROW BEGIN
  DECLARE dexMod INT;

  SET dexMod = FLOOR((NEW.Dexterity - 10) / 2);

  UPDATE CharacterStats
  SET Initiative = dexMod
  WHERE idCharacter = NEW.idCharacter;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_UpdateSavingThrows` AFTER INSERT ON `attribute` FOR EACH ROW BEGIN
  DECLARE strMod, dexMod, conMod, intMod, wisMod, chaMod INT;
  DECLARE profBonus TINYINT;

  SET strMod = FLOOR((NEW.Strength - 10) / 2);
  SET dexMod = FLOOR((NEW.Dexterity - 10) / 2);
  SET conMod = FLOOR((NEW.Constitution - 10) / 2);
  SET intMod = FLOOR((NEW.Intelligence - 10) / 2);
  SET wisMod = FLOOR((NEW.Wisdom - 10) / 2);
  SET chaMod = FLOOR((NEW.Charisma - 10) / 2);

  SELECT ProficiencyBonus INTO profBonus FROM `Character` WHERE idCharacter = NEW.idCharacter;

  INSERT INTO SavingThrows (
    idCharacter, Strength, Dexterity, Constitution, Intelligence, Wisdom, Charisma
  )
  SELECT
    NEW.idCharacter,
    strMod + profBonus * SavingThrowsProficiency.Strength,
    dexMod + profBonus * SavingThrowsProficiency.Dexterity,
    conMod + profBonus * SavingThrowsProficiency.Constitution,
    intMod + profBonus * SavingThrowsProficiency.Intelligence,
    wisMod + profBonus * SavingThrowsProficiency.Wisdom,
    chaMod + profBonus * SavingThrowsProficiency.Charisma
  FROM SavingThrowsProficiency
  WHERE SavingThrowsProficiency.idCharacter = NEW.idCharacter;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_UpdateSkills` AFTER INSERT ON `attribute` FOR EACH ROW BEGIN
  DECLARE strMod, dexMod, conMod, intMod, wisMod, chaMod INT;
  DECLARE profBonus TINYINT;

  SET strMod = FLOOR((NEW.Strength - 10) / 2);
  SET dexMod = FLOOR((NEW.Dexterity - 10) / 2);
  SET conMod = FLOOR((NEW.Constitution - 10) / 2);
  SET intMod = FLOOR((NEW.Intelligence - 10) / 2);
  SET wisMod = FLOOR((NEW.Wisdom - 10) / 2);
  SET chaMod = FLOOR((NEW.Charisma - 10) / 2);

  SELECT ProficiencyBonus INTO profBonus FROM `Character` WHERE idCharacter = NEW.idCharacter;

  INSERT INTO Skill (
    idCharacter, Acrobatics, AnimalHandling, Athletics, Deception, History,
    Insight, Intimidation, Investigation, Medicine, Nature, Perception,
    Performance, Persuasion, Religion, SleightOfHand, Stealth, Survival
  )
  SELECT
    NEW.idCharacter,
    dexMod + profBonus * SkillProficiency.Acrobatics,
    wisMod + profBonus * SkillProficiency.AnimalHandling,
    strMod + profBonus * SkillProficiency.Athletics,
    chaMod + profBonus * SkillProficiency.Deception,
    intMod + profBonus * SkillProficiency.History,
    wisMod + profBonus * SkillProficiency.Insight,
    chaMod + profBonus * SkillProficiency.Intimidation,
    intMod + profBonus * SkillProficiency.Investigation,
    wisMod + profBonus * SkillProficiency.Medicine,
    intMod + profBonus * SkillProficiency.Nature,
    wisMod + profBonus * SkillProficiency.Perception,
    chaMod + profBonus * SkillProficiency.Performance,
    chaMod + profBonus * SkillProficiency.Persuasion,
    intMod + profBonus * SkillProficiency.Religion,
    dexMod + profBonus * SkillProficiency.SleightOfHand,
    dexMod + profBonus * SkillProficiency.Stealth,
    wisMod + profBonus * SkillProficiency.Survival
  FROM SkillProficiency
  WHERE SkillProficiency.idCharacter = NEW.idCharacter;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_UpdateInitiative_Update` AFTER UPDATE ON `attribute` FOR EACH ROW BEGIN
  DECLARE dexMod INT;

  SET dexMod = FLOOR((NEW.Dexterity - 10) / 2);

  UPDATE CharacterStats
  SET Initiative = dexMod
  WHERE idCharacter = NEW.idCharacter;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_UpdateSavingThrows_update` AFTER UPDATE ON `attribute` FOR EACH ROW BEGIN
  DECLARE strMod, dexMod, conMod, intMod, wisMod, chaMod INT;
  DECLARE profBonus TINYINT;

  SET strMod = FLOOR((NEW.Strength - 10) / 2);
  SET dexMod = FLOOR((NEW.Dexterity - 10) / 2);
  SET conMod = FLOOR((NEW.Constitution - 10) / 2);
  SET intMod = FLOOR((NEW.Intelligence - 10) / 2);
  SET wisMod = FLOOR((NEW.Wisdom - 10) / 2);
  SET chaMod = FLOOR((NEW.Charisma - 10) / 2);

  SELECT ProficiencyBonus INTO profBonus FROM `Character` WHERE idCharacter = NEW.idCharacter;

  INSERT INTO SavingThrows (
    idCharacter, Strength, Dexterity, Constitution, Intelligence, Wisdom, Charisma
  )
  SELECT
    NEW.idCharacter,
    strMod + profBonus * SavingThrowsProficiency.Strength,
    dexMod + profBonus * SavingThrowsProficiency.Dexterity,
    conMod + profBonus * SavingThrowsProficiency.Constitution,
    intMod + profBonus * SavingThrowsProficiency.Intelligence,
    wisMod + profBonus * SavingThrowsProficiency.Wisdom,
    chaMod + profBonus * SavingThrowsProficiency.Charisma
  FROM SavingThrowsProficiency
  WHERE SavingThrowsProficiency.idCharacter = NEW.idCharacter;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_UpdateSkills_update` AFTER UPDATE ON `attribute` FOR EACH ROW BEGIN
  DECLARE strMod, dexMod, conMod, intMod, wisMod, chaMod INT;
  DECLARE profBonus TINYINT;

  SET strMod = FLOOR((NEW.Strength - 10) / 2);
  SET dexMod = FLOOR((NEW.Dexterity - 10) / 2);
  SET conMod = FLOOR((NEW.Constitution - 10) / 2);
  SET intMod = FLOOR((NEW.Intelligence - 10) / 2);
  SET wisMod = FLOOR((NEW.Wisdom - 10) / 2);
  SET chaMod = FLOOR((NEW.Charisma - 10) / 2);

  SELECT ProficiencyBonus INTO profBonus FROM `Character` WHERE idCharacter = NEW.idCharacter;

  INSERT INTO Skill (
    idCharacter, Acrobatics, AnimalHandling, Athletics, Deception, History,
    Insight, Intimidation, Investigation, Medicine, Nature, Perception,
    Performance, Persuasion, Religion, SleightOfHand, Stealth, Survival
  )
  SELECT
    NEW.idCharacter,
    dexMod + profBonus * SkillProficiency.Acrobatics,
    wisMod + profBonus * SkillProficiency.AnimalHandling,
    strMod + profBonus * SkillProficiency.Athletics,
    chaMod + profBonus * SkillProficiency.Deception,
    intMod + profBonus * SkillProficiency.History,
    wisMod + profBonus * SkillProficiency.Insight,
    chaMod + profBonus * SkillProficiency.Intimidation,
    intMod + profBonus * SkillProficiency.Investigation,
    wisMod + profBonus * SkillProficiency.Medicine,
    intMod + profBonus * SkillProficiency.Nature,
    wisMod + profBonus * SkillProficiency.Perception,
    chaMod + profBonus * SkillProficiency.Performance,
    chaMod + profBonus * SkillProficiency.Persuasion,
    intMod + profBonus * SkillProficiency.Religion,
    dexMod + profBonus * SkillProficiency.SleightOfHand,
    dexMod + profBonus * SkillProficiency.Stealth,
    wisMod + profBonus * SkillProficiency.Survival
  FROM SkillProficiency
  WHERE SkillProficiency.idCharacter = NEW.idCharacter;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `character`
--

DROP TABLE IF EXISTS `character`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `character` (
  `idCharacter` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) NOT NULL,
  `Race` varchar(45) NOT NULL,
  `Class` varchar(45) NOT NULL,
  `Experience` int NOT NULL,
  `Level` tinyint NOT NULL,
  `ProficiencyBonus` tinyint NOT NULL,
  PRIMARY KEY (`idCharacter`),
  UNIQUE KEY `idCharacter_UNIQUE` (`idCharacter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character`
--

LOCK TABLES `character` WRITE;
/*!40000 ALTER TABLE `character` DISABLE KEYS */;
/*!40000 ALTER TABLE `character` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_UpdateLevelAndProficiency` BEFORE UPDATE ON `character` FOR EACH ROW BEGIN
  DECLARE newLevel INT;
  DECLARE newProficiencyBonus TINYINT;

  SELECT Level, ProficiencyBonus
  INTO newLevel, newProficiencyBonus
  FROM ExperienceLevelMap
  WHERE NEW.Experience >= MinExperience
  ORDER BY MinExperience DESC
  LIMIT 1;

  SET NEW.Level = newLevel;
  SET NEW.ProficiencyBonus = newProficiencyBonus;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `character_ballte_stats`
--

DROP TABLE IF EXISTS `character_ballte_stats`;
/*!50001 DROP VIEW IF EXISTS `character_ballte_stats`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `character_ballte_stats` AS SELECT 
 1 AS `Имя персонажа`,
 1 AS `Максимум ХП`,
 1 AS `Текущее ХП`,
 1 AS `Класс Доспеха`,
 1 AS `Инициатива`,
 1 AS `Скорость`,
 1 AS `Спасбросок Сила`,
 1 AS `Спасбросок Ловкость`,
 1 AS `Спасбросок Телосложение`,
 1 AS `Спасбросок Интеллект`,
 1 AS `Спасбросок Мудрость`,
 1 AS `Спасбросок Харизма`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `character_skills_and_attribute`
--

DROP TABLE IF EXISTS `character_skills_and_attribute`;
/*!50001 DROP VIEW IF EXISTS `character_skills_and_attribute`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `character_skills_and_attribute` AS SELECT 
 1 AS `Имя персонажа`,
 1 AS `Сила`,
 1 AS `Ловкость`,
 1 AS `Телосложение`,
 1 AS `Интеллект`,
 1 AS `Мудрость`,
 1 AS `Харизма`,
 1 AS `Акробатика`,
 1 AS `Уход за животными`,
 1 AS `Атлетика`,
 1 AS `Обман`,
 1 AS `История`,
 1 AS `Проницательность`,
 1 AS `Запугивание`,
 1 AS `Анализ`,
 1 AS `Медицина`,
 1 AS `Природа`,
 1 AS `Восприятие`,
 1 AS `Выступление`,
 1 AS `Убеждение`,
 1 AS `Религия`,
 1 AS `Ловкость рук`,
 1 AS `Скрытность`,
 1 AS `Выживание`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `characterstats`
--

DROP TABLE IF EXISTS `characterstats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `characterstats` (
  `idCharacter` int NOT NULL,
  `MaxHP` smallint NOT NULL,
  `CurrentHP` smallint NOT NULL,
  `ArmorClass` tinyint NOT NULL,
  `Initiative` tinyint NOT NULL,
  `Speed` smallint DEFAULT NULL,
  PRIMARY KEY (`idCharacter`),
  CONSTRAINT `fk_CharacterStats_Character1` FOREIGN KEY (`idCharacter`) REFERENCES `character` (`idCharacter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `characterstats`
--

LOCK TABLES `characterstats` WRITE;
/*!40000 ALTER TABLE `characterstats` DISABLE KEYS */;
/*!40000 ALTER TABLE `characterstats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `experiencelevelmap`
--

DROP TABLE IF EXISTS `experiencelevelmap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `experiencelevelmap` (
  `Level` int NOT NULL,
  `MinExperience` int NOT NULL,
  `ProficiencyBonus` tinyint NOT NULL,
  PRIMARY KEY (`Level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `experiencelevelmap`
--

LOCK TABLES `experiencelevelmap` WRITE;
/*!40000 ALTER TABLE `experiencelevelmap` DISABLE KEYS */;
INSERT INTO `experiencelevelmap` VALUES (1,0,2),(2,300,2),(3,900,2),(4,2700,2),(5,6500,3),(6,14000,3),(7,23000,3),(8,34000,3),(9,48000,4),(10,64000,4),(11,85000,4),(12,100000,4),(13,120000,5),(14,140000,5),(15,165000,5),(16,195000,5),(17,225000,6),(18,265000,6),(19,305000,6),(20,355000,6);
/*!40000 ALTER TABLE `experiencelevelmap` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `savingthrows`
--

DROP TABLE IF EXISTS `savingthrows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `savingthrows` (
  `idCharacter` int NOT NULL,
  `Strength` tinyint NOT NULL,
  `Dexterity` tinyint NOT NULL,
  `Constitution` tinyint NOT NULL,
  `Intelligence` tinyint NOT NULL,
  `Wisdom` tinyint NOT NULL,
  `Charisma` tinyint NOT NULL,
  PRIMARY KEY (`idCharacter`),
  CONSTRAINT `fk_SavingThrows_Character1` FOREIGN KEY (`idCharacter`) REFERENCES `character` (`idCharacter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `savingthrows`
--

LOCK TABLES `savingthrows` WRITE;
/*!40000 ALTER TABLE `savingthrows` DISABLE KEYS */;
/*!40000 ALTER TABLE `savingthrows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `savingthrowsproficiency`
--

DROP TABLE IF EXISTS `savingthrowsproficiency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `savingthrowsproficiency` (
  `idCharacter` int NOT NULL,
  `Strength` tinyint NOT NULL,
  `Dexterity` tinyint NOT NULL,
  `Constitution` tinyint NOT NULL,
  `Intelligence` tinyint NOT NULL,
  `Wisdom` tinyint NOT NULL,
  `Charisma` tinyint NOT NULL,
  PRIMARY KEY (`idCharacter`),
  CONSTRAINT `fk_SavingThrows_Character10` FOREIGN KEY (`idCharacter`) REFERENCES `character` (`idCharacter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `savingthrowsproficiency`
--

LOCK TABLES `savingthrowsproficiency` WRITE;
/*!40000 ALTER TABLE `savingthrowsproficiency` DISABLE KEYS */;
/*!40000 ALTER TABLE `savingthrowsproficiency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skill`
--

DROP TABLE IF EXISTS `skill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skill` (
  `idCharacter` int NOT NULL,
  `Acrobatics` tinyint NOT NULL,
  `AnimalHandling` tinyint NOT NULL,
  `Athletics` tinyint NOT NULL,
  `Deception` tinyint NOT NULL,
  `History` tinyint NOT NULL,
  `Insight` tinyint NOT NULL,
  `Intimidation` tinyint NOT NULL,
  `Investigation` tinyint NOT NULL,
  `Medicine` tinyint NOT NULL,
  `Nature` tinyint NOT NULL,
  `Perception` tinyint NOT NULL,
  `Performance` tinyint NOT NULL,
  `Persuasion` tinyint NOT NULL,
  `Religion` tinyint NOT NULL,
  `SleightOfHand` tinyint NOT NULL,
  `Stealth` tinyint NOT NULL,
  `Survival` tinyint NOT NULL,
  PRIMARY KEY (`idCharacter`),
  CONSTRAINT `fk_Skill_Character1` FOREIGN KEY (`idCharacter`) REFERENCES `character` (`idCharacter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skill`
--

LOCK TABLES `skill` WRITE;
/*!40000 ALTER TABLE `skill` DISABLE KEYS */;
/*!40000 ALTER TABLE `skill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skillproficiency`
--

DROP TABLE IF EXISTS `skillproficiency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skillproficiency` (
  `idCharacter` int NOT NULL,
  `Acrobatics` tinyint NOT NULL,
  `AnimalHandling` tinyint NOT NULL,
  `Athletics` tinyint NOT NULL,
  `Deception` tinyint NOT NULL,
  `History` tinyint NOT NULL,
  `Insight` tinyint NOT NULL,
  `Intimidation` tinyint NOT NULL,
  `Investigation` tinyint NOT NULL,
  `Medicine` tinyint NOT NULL,
  `Nature` tinyint NOT NULL,
  `Perception` tinyint NOT NULL,
  `Performance` tinyint NOT NULL,
  `Persuasion` tinyint NOT NULL,
  `Religion` tinyint NOT NULL,
  `SleightOfHand` tinyint NOT NULL,
  `Stealth` tinyint NOT NULL,
  `Survival` tinyint NOT NULL,
  PRIMARY KEY (`idCharacter`),
  CONSTRAINT `fk_SkillProficiency_Character1` FOREIGN KEY (`idCharacter`) REFERENCES `character` (`idCharacter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skillproficiency`
--

LOCK TABLES `skillproficiency` WRITE;
/*!40000 ALTER TABLE `skillproficiency` DISABLE KEYS */;
/*!40000 ALTER TABLE `skillproficiency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'dnd'
--

--
-- Dumping routines for database 'dnd'
--
/*!50003 DROP FUNCTION IF EXISTS `getmodifier` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getmodifier`(stat TINYINT) RETURNS tinyint
    DETERMINISTIC
BEGIN
  DECLARE mod_value TINYINT;
  SET mod_value = FLOOR((stat - 10) / 2);
  RETURN mod_value;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreateCharacter` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateCharacter`(
    IN character_name VARCHAR(45),
    IN character_race VARCHAR(45),
    IN character_class VARCHAR(45),
    IN character_experience INT,
    IN character_max_hp SMALLINT,
    IN character_current_hp SMALLINT,
    IN character_armor_class TINYINT,
    IN character_speed SMALLINT,

    IN character_str TINYINT,
    IN character_dex TINYINT,
    IN character_con TINYINT,
    IN character_int TINYINT,
    IN character_wis TINYINT,
    IN character_cha TINYINT,

    IN skill_acrobatics TINYINT,
    IN skill_animal_handling TINYINT,
    IN skill_athletics TINYINT,
    IN skill_deception TINYINT,
    IN skill_history TINYINT,
    IN skill_insight TINYINT,
    IN skill_intimidation TINYINT,
    IN skill_investigation TINYINT,
    IN skill_medicine TINYINT,
    IN skill_nature TINYINT,
    IN skill_perception TINYINT,
    IN skill_performance TINYINT,
    IN skill_persuasion TINYINT,
    IN skill_religion TINYINT,
    IN skill_sleight_of_hand TINYINT,
    IN skill_stealth TINYINT,
    IN skill_survival TINYINT,

    IN save_strength TINYINT,
    IN save_dexterity TINYINT,
    IN save_constitution TINYINT,
    IN save_intelligence TINYINT,
    IN save_wisdom TINYINT,
    IN save_charisma TINYINT
)
BEGIN
    DECLARE v_Level INT;
    DECLARE v_ProfBonus TINYINT;
    DECLARE v_CharId INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ошибка при создании персонажа';
    END;

    START TRANSACTION;

    SELECT Level, ProficiencyBonus INTO v_Level, v_ProfBonus
    FROM ExperienceLevelMap
    WHERE character_experience >= MinExperience
    ORDER BY MinExperience DESC
    LIMIT 1;

    INSERT INTO `Character` (Name, Race, Class, Experience, Level, ProficiencyBonus)
    VALUES (character_name, character_race, character_class, character_experience, v_Level, v_ProfBonus);

    SET v_CharId = LAST_INSERT_ID();

    INSERT INTO SkillProficiency (
        idCharacter, Acrobatics, AnimalHandling, Athletics, Deception, History,
        Insight, Intimidation, Investigation, Medicine, Nature, Perception,
        Performance, Persuasion, Religion, SleightOfHand, Stealth, Survival
    )
    VALUES (
        v_CharId, skill_acrobatics, skill_animal_handling, skill_athletics, skill_deception, skill_history,
        skill_insight, skill_intimidation, skill_investigation, skill_medicine, skill_nature, skill_perception,
        skill_performance, skill_persuasion, skill_religion, skill_sleight_of_hand, skill_stealth, skill_survival
    );

    INSERT INTO SavingThrowsProficiency (
        idCharacter, Strength, Dexterity, Constitution, Intelligence, Wisdom, Charisma
    )
    VALUES (
        v_CharId, save_strength, save_dexterity, save_constitution, save_intelligence, save_wisdom, save_charisma
    );

    INSERT INTO CharacterStats (idCharacter, MaxHP, CurrentHP, ArmorClass, Initiative, Speed)
    VALUES (v_CharId, character_max_hp, character_current_hp, character_armor_class, 0, character_speed);

    INSERT INTO Attribute (idCharacter, Strength, Dexterity, Constitution, Intelligence, Wisdom, Charisma)
    VALUES (v_CharId, character_str, character_dex, character_con, character_int, character_wis, character_cha);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `character_ballte_stats`
--

/*!50001 DROP VIEW IF EXISTS `character_ballte_stats`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `character_ballte_stats` AS select `character`.`Name` AS `Имя персонажа`,`characterstats`.`MaxHP` AS `Максимум ХП`,`characterstats`.`CurrentHP` AS `Текущее ХП`,`characterstats`.`ArmorClass` AS `Класс Доспеха`,`characterstats`.`Initiative` AS `Инициатива`,`characterstats`.`Speed` AS `Скорость`,`savingthrows`.`Strength` AS `Спасбросок Сила`,`savingthrows`.`Dexterity` AS `Спасбросок Ловкость`,`savingthrows`.`Constitution` AS `Спасбросок Телосложение`,`savingthrows`.`Intelligence` AS `Спасбросок Интеллект`,`savingthrows`.`Wisdom` AS `Спасбросок Мудрость`,`savingthrows`.`Charisma` AS `Спасбросок Харизма` from ((`character` join `characterstats` on((`character`.`idCharacter` = `characterstats`.`idCharacter`))) join `savingthrows` on((`character`.`idCharacter` = `savingthrows`.`idCharacter`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `character_skills_and_attribute`
--

/*!50001 DROP VIEW IF EXISTS `character_skills_and_attribute`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `character_skills_and_attribute` AS select `character`.`Name` AS `Имя персонажа`,`attribute`.`Strength` AS `Сила`,`attribute`.`Dexterity` AS `Ловкость`,`attribute`.`Constitution` AS `Телосложение`,`attribute`.`Intelligence` AS `Интеллект`,`attribute`.`Wisdom` AS `Мудрость`,`attribute`.`Charisma` AS `Харизма`,`skill`.`Acrobatics` AS `Акробатика`,`skill`.`AnimalHandling` AS `Уход за животными`,`skill`.`Athletics` AS `Атлетика`,`skill`.`Deception` AS `Обман`,`skill`.`History` AS `История`,`skill`.`Insight` AS `Проницательность`,`skill`.`Intimidation` AS `Запугивание`,`skill`.`Investigation` AS `Анализ`,`skill`.`Medicine` AS `Медицина`,`skill`.`Nature` AS `Природа`,`skill`.`Perception` AS `Восприятие`,`skill`.`Performance` AS `Выступление`,`skill`.`Persuasion` AS `Убеждение`,`skill`.`Religion` AS `Религия`,`skill`.`SleightOfHand` AS `Ловкость рук`,`skill`.`Stealth` AS `Скрытность`,`skill`.`Survival` AS `Выживание` from ((`character` join `attribute` on((`character`.`idCharacter` = `attribute`.`idCharacter`))) join `skill` on((`character`.`idCharacter` = `skill`.`idCharacter`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-09  0:35:01
