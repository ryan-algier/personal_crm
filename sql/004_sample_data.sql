-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: personal_crm_sample
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `personal_crm_sample`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `personal_crm_sample` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `personal_crm_sample`;

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `industry` varchar(100) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companies`
--

LOCK TABLES `companies` WRITE;
/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
INSERT INTO `companies` VALUES (1,'Smith-Davis','Healthcare','https://www.smith-davis.com','Approach something detail strategy stand TV instead issue.','2026-07-13 00:10:05'),(2,'Marquez-Castillo','Healthcare','https://www.marquez-castill.com','At charge certainly.','2026-07-13 00:10:05'),(3,'Martin, Sims and Kemp','Technology','https://www.martinsimsandke.com',NULL,'2026-07-13 00:10:05'),(4,'Johnson-Sims','Healthcare','https://www.johnson-sims.com',NULL,'2026-07-13 00:10:05'),(5,'Mckinney-Juarez','Technology','https://www.mckinney-juarez.com',NULL,'2026-07-13 00:10:05'),(6,'Adams, Blackwell and Wilson','Healthcare','https://www.adamsblackwella.com',NULL,'2026-07-13 00:10:05'),(7,'Torres, Jones and Kelly','Retail','https://www.torresjonesandk.com','Past safe hand defense.','2026-07-13 00:10:05'),(8,'Todd-Reynolds','Healthcare','https://www.todd-reynolds.com',NULL,'2026-07-13 00:10:05'),(9,'Rogers and Sons','Manufacturing','https://www.rogersandsons.com',NULL,'2026-07-13 00:10:05'),(10,'Mclean, Stanley and Howard','Manufacturing','https://www.mcleanstanleyan.com',NULL,'2026-07-13 00:10:05'),(11,'Thomas-Green','Finance','https://www.thomas-green.com',NULL,'2026-07-13 00:10:05'),(12,'Kennedy, Ramirez and Richardson','Healthcare','https://www.kennedyramireza.com',NULL,'2026-07-13 00:10:05'),(13,'Ortiz-Murphy','Retail','https://www.ortiz-murphy.com','Explain single industry let value realize.','2026-07-13 00:10:05'),(14,'Fields Ltd','Retail','https://www.fieldsltd.com',NULL,'2026-07-13 00:10:05'),(15,'Haynes-Guerra','Technology','https://www.haynes-guerra.com',NULL,'2026-07-13 00:10:05'),(16,'Mitchell, Jackson and Fisher','Healthcare','https://www.mitchelljackson.com',NULL,'2026-07-13 00:10:05'),(17,'Arias LLC','Retail','https://www.ariasllc.com',NULL,'2026-07-13 00:10:05');
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contacts`
--

DROP TABLE IF EXISTS `contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contacts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `company_id` int DEFAULT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `linkedin_url` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `how_we_met` enum('LinkedIn','college','life','referral','cold outreach','other') DEFAULT NULL,
  `met_on` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `contacts_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts`
--

LOCK TABLES `contacts` WRITE;
/*!40000 ALTER TABLE `contacts` DISABLE KEYS */;
INSERT INTO `contacts` VALUES (1,2,'Brian','Robles','terri28@example.com','5565706341','https://linkedin.com/in/brian-robles-9531','Chicago','LinkedIn','2010-01-01','2026-07-13 00:10:05'),(2,9,'Tiffany','Stone','nblack@example.com','2912336093','https://linkedin.com/in/tiffany-stone-4678','Chicago','life','2010-01-01','2026-07-13 00:10:05'),(3,3,'Cheryl','Rivera','ashley59@example.org','0744707122','https://linkedin.com/in/cheryl-rivera-5162','Washington D.C.','cold outreach','2010-01-01','2026-07-13 00:10:05'),(4,2,'Mary','Smith','peterreed@example.com','3571007340','https://linkedin.com/in/mary-smith-4148','Chicago','life','2018-01-01','2026-07-13 00:10:05'),(5,5,'Audrey','Morales','kerriandrews@example.net','3256376787','https://linkedin.com/in/audrey-morales-4631','Washington D.C.','cold outreach','2018-01-01','2026-07-13 00:10:05'),(6,6,'Julie','Carr','stephanieweiss@example.com','3906167541','https://linkedin.com/in/julie-carr-6960','Los Angeles','college','2022-09-03','2026-07-13 00:10:05'),(7,3,'Erin','Camacho','amanda57@example.net','2781376968','https://linkedin.com/in/erin-camacho-5598','New York City','referral','2026-04-15','2026-07-13 00:10:05'),(8,3,'Kelly','Powers','lawrencerobin@example.com','2107161895','https://linkedin.com/in/kelly-powers-9797','Washington D.C.','life','2026-04-23','2026-07-13 00:10:05'),(9,8,'Christopher','Lane','wcox@example.org','1263052482','https://linkedin.com/in/christopher-lane-5707','Houston','life','2026-01-24','2026-07-13 00:10:05'),(10,7,'Teresa','Woodard','lisaday@example.net','8387924572','https://linkedin.com/in/teresa-woodard-3460','New York City','LinkedIn','2026-01-24','2026-07-13 00:10:05'),(11,2,'Dylan','Brown','gilbertnathaniel@example.com','2418245193','https://linkedin.com/in/dylan-brown-3106','Washington D.C.','LinkedIn',NULL,'2026-07-13 00:10:05'),(12,2,'Susan','Baker','goodmaxwell@example.org','0384445929','https://linkedin.com/in/susan-baker-3503','Los Angeles','other','2026-04-29','2026-07-13 00:10:05'),(13,10,'Sabrina','Santiago','aprilbray@example.com','4271971855','https://linkedin.com/in/sabrina-santiago-5872','Los Angeles','LinkedIn','2026-04-29','2026-07-13 00:10:05'),(14,12,'Leah','Allen','jessicacollier@example.net','1355795521','https://linkedin.com/in/leah-allen-4143','Houston','life','2019-01-01','2026-07-13 00:10:05'),(15,2,'Katherine','Mendoza','eanderson@example.com','4283796783','https://linkedin.com/in/katherine-mendoza-3365','Chicago','LinkedIn','2026-02-17','2026-07-13 00:10:05'),(16,NULL,'Kevin','Foster','dereklee@example.org','1611883958','https://linkedin.com/in/kevin-foster-9238','Washington D.C.','other','2010-01-01','2026-07-13 00:10:05'),(17,2,'Rachel','Tyler','mariadavis@example.com','4021676895','https://linkedin.com/in/rachel-tyler-7639','Washington D.C.','LinkedIn','2019-01-01','2026-07-13 00:10:05'),(18,NULL,'Aaron','Silva','pbowman@example.net','9235991961','https://linkedin.com/in/aaron-silva-9622','Washington D.C.','referral','2019-08-01','2026-07-13 00:10:05'),(19,NULL,'Angela','Simpson','christianjohnson@example.org','1875887860','https://linkedin.com/in/angela-simpson-8352','Washington D.C.','referral','2019-08-01','2026-07-13 00:10:05'),(20,13,'Melissa','Gill','gmiller@example.net','4248117600','https://linkedin.com/in/melissa-gill-5910','New York City','referral','2017-08-01','2026-07-13 00:10:05'),(21,11,'Megan','Murphy','nicole62@example.net','0326376850','https://linkedin.com/in/megan-murphy-3643','Chicago','life','2026-05-01','2026-07-13 00:10:05'),(22,2,'Ashley','Buchanan','markmahoney@example.org','0096563252','https://linkedin.com/in/ashley-buchanan-3781','Washington D.C.','college','2018-01-01','2026-07-13 00:10:05'),(23,14,'Evan','Hoffman','vhill@example.net','1636665286','https://linkedin.com/in/evan-hoffman-2271','Houston','other',NULL,'2026-07-13 00:10:05'),(24,15,'Carolyn','Gonzalez','gregory82@example.com','0389777197','https://linkedin.com/in/carolyn-gonzalez-8465','Washington D.C.','life','2026-05-19','2026-07-13 00:10:05'),(25,16,'Scott','Carter','michellereilly@example.com','4355941252','https://linkedin.com/in/scott-carter-6273','New York City','LinkedIn','2018-01-01','2026-07-13 00:10:05'),(26,17,'Pamela','Perry','oadams@example.net','4569593908','https://linkedin.com/in/pamela-perry-1094','New York City','referral','2026-06-01','2026-07-13 00:10:05'),(27,NULL,'Amanda','Hanson','jenniferdavis@example.com','2179225406','https://linkedin.com/in/amanda-hanson-1811','Chicago','referral','2018-01-01','2026-07-13 00:10:05'),(28,NULL,'Dustin','Freeman','burgessashley@example.org','3652020783','https://linkedin.com/in/dustin-freeman-7275','New York City','referral','2018-01-01','2026-07-13 00:10:05'),(29,NULL,'Sheri','Brown','mshea@example.net','5049570007','https://linkedin.com/in/sheri-brown-0264','Houston','other','2018-01-01','2026-07-13 00:10:05'),(30,NULL,'Matthew','Sullivan','bentleysusan@example.com','5659674172','https://linkedin.com/in/matthew-sullivan-7661','Houston','other','2018-01-01','2026-07-13 00:10:05'),(31,NULL,'David','Mcneil','zcraig@example.com','3833703459','https://linkedin.com/in/david-mcneil-7790','Washington D.C.','referral','2018-01-01','2026-07-13 00:10:05'),(32,2,'Beverly','Gibson','kleincraig@example.org','3294797600','https://linkedin.com/in/beverly-gibson-1902','Washington D.C.','referral','2018-01-01','2026-07-13 00:10:05');
/*!40000 ALTER TABLE `contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interactions`
--

DROP TABLE IF EXISTS `interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `contact_id` int NOT NULL,
  `date` date DEFAULT NULL,
  `type` enum('email','call','in person','LinkedIn','thank you','other') DEFAULT NULL,
  `summary` text,
  `outcome` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `thank_you_required` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `contact_id` (`contact_id`),
  CONSTRAINT `interactions_ibfk_1` FOREIGN KEY (`contact_id`) REFERENCES `contacts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interactions`
--

LOCK TABLES `interactions` WRITE;
/*!40000 ALTER TABLE `interactions` DISABLE KEYS */;
INSERT INTO `interactions` VALUES (1,9,'2025-08-10','LinkedIn','Professional wrong discuss between environment debate.','Tree game friend treat economic improve child trade.','2026-07-13 00:10:05',1),(2,9,'2025-07-04','thank you','Thought myself usually.',NULL,'2026-07-13 00:10:05',0),(3,10,'2025-08-29','in person','Someone there between laugh event allow middle finish.','Two within director beautiful page.','2026-07-13 00:10:05',1),(4,23,'2026-02-20','in person','Hold mouth generation teacher wide attorney own.','Describe adult final or low make.','2026-07-13 00:10:05',1),(5,23,'2025-10-29','thank you','Whole result analysis end minute.',NULL,'2026-07-13 00:10:05',0),(6,10,'2025-08-31','thank you','Probably protect type we student community general.',NULL,'2026-07-13 00:10:05',0),(7,13,'2026-09-03','other','Cell color knowledge local democratic center PM.','Them line serve over yard indicate.','2026-07-13 00:10:05',0),(8,4,'2026-10-03','LinkedIn','Enjoy place possible.','Watch throw former bar fact.','2026-07-13 00:10:05',0),(9,13,'2026-05-22','in person','Expect computer son local network economic their.','Another company her as let coach.','2026-07-13 00:10:05',0),(10,8,'2026-06-16','other','Prevent yes position interesting fact ok.','As town small conference PM white.','2026-07-13 00:10:05',0),(11,12,'2025-07-10','call','Find write another garden difference team hold.','Financial full better hotel.','2026-07-13 00:10:05',0),(12,3,'2025-12-21','email','Every tonight point friend support onto near.','Easy wide two against measure space.','2026-07-13 00:10:05',0),(13,7,'2026-05-07','in person','Rate service by laugh window environment.','Question help would indeed.','2026-07-13 00:10:05',1),(14,7,'2026-04-12','thank you','For small for design.',NULL,'2026-07-13 00:10:05',0),(15,23,'2026-02-26','other','Share generation cell one available explain church.','Foreign rate include fly soon.','2026-07-13 00:10:05',0),(16,11,'2026-11-14','in person','Tree lose rock who mother listen dream.','Picture prove serious low.','2026-07-13 00:10:05',0),(17,12,'2025-02-28','other','Anyone their soldier fish hospital case.','Play represent leg else behind hit action.','2026-07-13 00:10:05',0),(18,14,'2026-04-14','call','Which only once thus candidate play top.','Reality student simply still building.','2026-07-13 00:10:05',0),(19,17,'2025-05-23','in person','General yeah seven morning say second.','Garden color mouth present.','2026-07-13 00:10:05',0),(20,13,'2025-11-09','other','Prevent weight tell various.','Friend fall at my.','2026-07-13 00:10:05',0),(21,8,'2026-05-07','other','Would improve pattern candidate to.','Point picture happy recently likely.','2026-07-13 00:10:05',0),(22,21,'2026-01-21','email','Nation clearly bring him move popular.','Fact skill answer own ball.','2026-07-13 00:10:05',0),(23,25,'2025-10-02','email','Himself serious note cost rule.',NULL,'2026-07-13 00:10:05',0),(24,24,'2025-03-26','other','Become similar than federal.',NULL,'2026-07-13 00:10:05',0),(25,2,'2025-08-07','email','Fire add that nature.','Woman require whole drug finally impact plan.','2026-07-13 00:10:05',0),(26,24,'2025-08-09','email','Treatment include nature group never.','Language then who commercial scientist special science.','2026-07-13 00:10:05',1),(27,24,'2026-03-25','thank you','Result throughout always answer.',NULL,'2026-07-13 00:10:05',0),(28,26,'2025-11-17','call','Range theory news read.','Play improve board area just hot.','2026-07-13 00:10:05',1),(29,26,'2026-01-26','thank you','Century record until center.','Bag industry finish community indicate picture rule benefit.','2026-07-13 00:10:05',0);
/*!40000 ALTER TABLE `interactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `referrals`
--

DROP TABLE IF EXISTS `referrals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `referrals` (
  `id` int NOT NULL AUTO_INCREMENT,
  `referrer_id` int NOT NULL,
  `referred_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `referrer_id` (`referrer_id`),
  KEY `referred_id` (`referred_id`),
  CONSTRAINT `referrals_ibfk_1` FOREIGN KEY (`referrer_id`) REFERENCES `contacts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `referrals_ibfk_2` FOREIGN KEY (`referred_id`) REFERENCES `contacts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_no_self_referral` CHECK ((`referrer_id` <> `referred_id`))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `referrals`
--

LOCK TABLES `referrals` WRITE;
/*!40000 ALTER TABLE `referrals` DISABLE KEYS */;
INSERT INTO `referrals` VALUES (1,3,7,'2026-07-13 00:10:05'),(2,1,9,'2026-07-13 00:10:05'),(3,9,10,'2026-07-13 00:10:05'),(4,3,8,'2026-07-13 00:10:05'),(5,1,12,'2026-07-13 00:10:05'),(6,1,15,'2026-07-13 00:10:05'),(7,1,21,'2026-07-13 00:10:05'),(8,1,23,'2026-07-13 00:10:05'),(9,12,24,'2026-07-13 00:10:05'),(10,1,26,'2026-07-13 00:10:05');
/*!40000 ALTER TABLE `referrals` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-01  1:38:02
