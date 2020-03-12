-- MySQL dump 10.16  Distrib 10.1.41-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: sistema_in
-- ------------------------------------------------------
-- Server version	10.1.41-MariaDB-0ubuntu0.18.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `fornecedores`
--

DROP TABLE IF EXISTS `fornecedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fornecedores` (
  `codfor` char(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TipFor` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nomefor` char(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fantasia` char(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `endereco` char(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bairro` char(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Codmun` char(7) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `municipio` char(35) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cep` char(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fone` char(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fax` char(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cgcfor` char(18) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `inscfor` char(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contato` char(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` char(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Pagina` char(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data` date DEFAULT NULL,
  `Classe` char(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Status` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NumConta` char(14) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CondPag` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Palm` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Sped` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Selecao` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Valor` decimal(20,2) DEFAULT NULL,
  `Comissao` decimal(20,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fornecedores`
--

LOCK TABLES `fornecedores` WRITE;
/*!40000 ALTER TABLE `fornecedores` DISABLE KEYS */;
INSERT INTO `fornecedores` VALUES ('00002','J','BELOCAP PRODUTOS CAPILARES LTDA.','BELOCAP PRODUTOS CAPILARES LTDA.','AUTO ESTRADA RIO D\'\'OURO, 800','PAVUNA','3304557','RIO DE JANEIRO','RJ','21535030','(0XX21) 516-4604','516-9139','30278428000838','83029935','EDUARDO','','','0000-00-00','001','01','','30','0','','X',2692.76,3.00),('00653','','SALVATORI INDUSTRIA E COM DE COSMETICOS','SALVATORI INDUSTRIA E COM DE COSMETICOS','NICOLAU CACCIATORI, 320','JARDIM DOS PIONEIROS','3541406','PRESIDENTE PRUDENTE','SP','19050340','018 3908-1805','','10454350000181','562309515110','','','','2018-04-16','','','210101  0446','','0','','X',3379.50,6.00),('00208','','BELOCAP - REDKEN','BELOCAP PRODUTOS CAPILARES LTDA','ROD.WASHINGTON LUIZ, 15509','PARQUE ELDORADO','','DUQUE DE CAXIAS','RJ','25240005','0300-3135151','','','77781226','','','','2006-02-03','001','01','','','0','','X',446.50,3.00),('00679','','DELLY DISTRIBUIDORA DE COSMETICOS E PRES','DELLY DISTRIBUIDORA DE COSMETICOS E PRES','ESTRADA CAMBOATA, 2207, GALPAO 2','MEU RANCHINHO','3304144','QUEIMADOS','RJ','26379160','21 2394-9191','','10601315000148','78683236','','','','2019-02-04','','','210101  0471','','0','','X',1037.99,3.00),('00008','J','CASA ADELINO PRODUTOS ANACONDA LTDA.','CASA ADELINO PRODUTOS ANACONDA LTDA.','AV CELSO GARCIA, 676','BRAS','3550308','SÃO PAULO','SP','03014000','11 2694.7766','11 2694.9050','60891371000132','102546846118','','','','0000-00-00','','','210101  0003','30','0','','X',0.00,3.00),('00179','','VICTORIA AUGUSTA COSMETICOS LTDA - EPP','VICTORIA AUGUSTA COSMETICOS LTDA - EPP','RUA ELISA GIGLIO DE OLIVEIRA, 35 ARMAZEM','RIO COTIA','3513009','COTIA','SP','06715420','(11)4616-2863','','06192722000171','278144980114','','','','2005-05-18','','','','','0','','X',23.80,3.00),('00004','J','LABORATORIO SKLEAN DO BRASIL LTDA','LABORATORIO SKLEAN DO BRASIL LTDA','AV. LOURENCO BELLOLI, 1010','PARQUE INDUSTRIAL','3534401','OSASCO','SP','06268110','11 3604.2600','','62635669000107','492458624117','INCORONATA/ROSANA','','','0000-00-00','001','01','','30','0','','X',226.78,3.00),('00156','J','ATALANTA LABORATORIO E COSMETICOS LTDA','ATALANTA LABORATORIO E COSMETICOS LTDA','RUA PASSADENA, 115','PQ.IND.SAN JOSÉ','3513009','COTIA','SP','06715864','(11)4703-5484','','61183729000135','278045885115','','','','0000-00-00','','','','30','0','','X',0.00,3.00);
/*!40000 ALTER TABLE `fornecedores` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-09-09 20:21:49