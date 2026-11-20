-- MySQL dump 10.13  Distrib 9.4.0, for macos14.7 (x86_64)
--
-- Host: localhost    Database: w3schools
-- ------------------------------------------------------
-- Server version	9.4.0

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
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `CustomerID` int NOT NULL,
  `CustomerName` varchar(100) NOT NULL,
  `ContactName` varchar(100) DEFAULT NULL,
  `Address` varchar(150) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `PostalCode` varchar(15) DEFAULT NULL,
  `Country` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`CustomerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (2,'Ana Trujillo Emparedados y helados','Ana Trujillo','Avda. de la Constitución 2222','México D.F.','5021','Mexico\r'),(3,'Antonio Moreno Taquería','Antonio Moreno','Mataderos 2312','México D.F.','5023','Mexico\r'),(4,'Around the Horn','Thomas Hardy','120 Hanover Sq.','London','WA1 1DP','UK\r'),(5,'Berglunds snabbköp','Christina Berglund','Berguvsvägen 8','Luleå','S-958 22','Sweden\r'),(6,'Blauer See Delikatessen','Hanna Moos','Forsterstr. 57','Mannheim','68306','Germany\r'),(7,'Blondel père et fils','Frédérique Citeaux','24, place Kléber','Strasbourg','67000','France\r'),(8,'Bólido Comidas preparadas','Martín Sommer','C/ Araquil, 67','Madrid','28023','Spain\r'),(9,'Bon app\'','Laurence Lebihans','12, rue des Bouchers','Marseille','13008','France\r'),(10,'Bottom-Dollar Marketse','Elizabeth Lincoln','23 Tsawassen Blvd.','Tsawassen','T2F 8M4','Canada\r'),(11,'B\'s Beverages','Victoria Ashworth','Fauntleroy Circus','London','EC2 5NT','UK\r'),(12,'Cactus Comidas para llevar','Patricio Simpson','Cerrito 333','Buenos Aires','1010','Argentina\r'),(13,'Centro comercial Moctezuma','Francisco Chang','Sierras de Granada 9993','México D.F.','5022','Mexico\r'),(14,'Chop-suey Chinese','Yang Wang','Hauptstr. 29','Bern','3012','Switzerland\r'),(15,'Comércio Mineiro','Pedro Afonso','Av. dos Lusíadas, 23','São Paulo','05432-043','Brazil\r'),(16,'Consolidated Holdings','Elizabeth Brown','Berkeley Gardens 12 Brewery','London','WX1 6LT','UK\r'),(17,'Drachenblut Delikatessend','Sven Ottlieb','Walserweg 21','Aachen','52066','Germany\r'),(18,'Du monde entier','Janine Labrune','67, rue des Cinquante Otages','Nantes','44000','France\r'),(19,'Eastern Connection','Ann Devon','35 King George','London','WX3 6FW','UK\r'),(20,'Ernst Handel','Roland Mendel','Kirchgasse 6','Graz','8010','Austria\r'),(21,'Familia Arquibaldo','Aria Cruz','Rua Orós, 92','São Paulo','05442-030','Brazil\r'),(22,'FISSA Fabrica Inter. Salchichas S.A.','Diego Roel','C/ Moralzarzal, 86','Madrid','28034','Spain\r'),(23,'Folies gourmandes','Martine Rancé','184, chaussée de Tournai','Lille','59000','France\r'),(24,'Folk och fä HB','Maria Larsson','Åkergatan 24','Bräcke','S-844 67','Sweden\r'),(25,'Frankenversand','Peter Franken','Berliner Platz 43','München','80805','Germany\r'),(26,'France restauration','Carine Schmitt','54, rue Royale','Nantes','44000','France\r'),(27,'Franchi S.p.A.','Paolo Accorti','Via Monte Bianco 34','Torino','10100','Italy\r'),(28,'Furia Bacalhau e Frutos do Mar','Lino Rodriguez','Jardim das rosas n. 32','Lisboa','1675','Portugal\r'),(29,'Galería del gastrónomo','Eduardo Saavedra','Rambla de Cataluña, 23','Barcelona','8022','Spain\r'),(30,'Godos Cocina Típica','José Pedro Freyre','C/ Romero, 33','Sevilla','41101','Spain\r'),(31,'Gourmet Lanchonetes','André Fonseca','Av. Brasil, 442','Campinas','04876-786','Brazil\r'),(32,'Great Lakes Food Market','Howard Snyder','2732 Baker Blvd.','Eugene','97403','USA\r'),(33,'GROSELLA-Restaurante','Manuel Pereira','5ª Ave. Los Palos Grandes','Caracas','1081','Venezuela\r'),(34,'Hanari Carnes','Mario Pontes','Rua do Paço, 67','Rio de Janeiro','05454-876','Brazil\r'),(35,'HILARIÓN-Abastos','Carlos Hernández','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','5022','Venezuela\r'),(36,'Hungry Coyote Import Store','Yoshi Latimer','City Center Plaza 516 Main St.','Elgin','97827','USA\r'),(37,'Hungry Owl All-Night Grocers','Patricia McKenna','8 Johnstown Road','Cork','','Ireland\r'),(38,'Island Trading','Helen Bennett','Garden House Crowther Way','Cowes','PO31 7PJ','UK\r'),(39,'Königlich Essen','Philip Cramer','Maubelstr. 90','Brandenburg','14776','Germany\r'),(40,'La corne d\'abondance','Daniel Tonini','67, avenue de l\'Europe','Versailles','78000','France\r'),(41,'La maison d\'Asie','Annette Roulet','1 rue Alsace-Lorraine','Toulouse','31000','France\r'),(42,'Laughing Bacchus Wine Cellars','Yoshi Tannamuri','1900 Oak St.','Vancouver','V3F 2K1','Canada\r'),(43,'Lazy K Kountry Store','John Steel','12 Orchestra Terrace','Walla Walla','99362','USA\r'),(44,'Lehmanns Marktstand','Renate Messner','Magazinweg 7','Frankfurt a.M.','60528','Germany\r'),(45,'Let\'s Stop N Shop','Jaime Yorres','87 Polk St. Suite 5','San Francisco','94117','USA\r'),(46,'LILA-Supermercado','Carlos González','Carrera 52 con Ave. Bolívar #65-98 Llano Largo','Barquisimeto','3508','Venezuela\r'),(47,'LINO-Delicateses','Felipe Izquierdo','Ave. 5 de Mayo Porlamar','I. de Margarita','4980','Venezuela\r'),(48,'Lonesome Pine Restaurant','Fran Wilson','89 Chiaroscuro Rd.','Portland','97219','USA\r'),(49,'Magazzini Alimentari Riuniti','Giovanni Rovelli','Via Ludovico il Moro 22','Bergamo','24100','Italy\r'),(50,'Maison Dewey','Catherine Dewey','Rue Joseph-Bens 532','Bruxelles','B-1180','Belgium\r'),(51,'Mère Paillarde','Jean Fresnière','43 rue St. Laurent','Montréal','H1J 1C3','Canada\r'),(52,'Morgenstern Gesundkost','Alexander Feuer','Heerstr. 22','Leipzig','4179','Germany\r'),(53,'North/South','Simon Crowther','South House 300 Queensbridge','London','SW7 1RZ','UK\r'),(54,'Océano Atlántico Ltda.','Yvonne Moncada','Ing. Gustavo Moncada 8585 Piso 20-A','Buenos Aires','1010','Argentina\r'),(55,'Old World Delicatessen','Rene Phillips','2743 Bering St.','Anchorage','99508','USA\r'),(56,'Ottilies Käseladen','Henriette Pfalzheim','Mehrheimerstr. 369','Köln','50739','Germany\r'),(57,'Paris spécialités','Marie Bertrand','265, boulevard Charonne','Paris','75012','France\r'),(58,'Pericles Comidas clásicas','Guillermo Fernández','Calle Dr. Jorge Cash 321','México D.F.','5033','Mexico\r'),(59,'Piccolo und mehr','Georg Pipps','Geislweg 14','Salzburg','5020','Austria\r'),(60,'Princesa Isabel Vinhoss','Isabel de Castro','Estrada da saúde n. 58','Lisboa','1756','Portugal\r'),(61,'Que Delícia','Bernardo Batista','Rua da Panificadora, 12','Rio de Janeiro','02389-673','Brazil\r'),(62,'Queen Cozinha','Lúcia Carvalho','Alameda dos Canàrios, 891','São Paulo','05487-020','Brazil\r'),(63,'QUICK-Stop','Horst Kloss','Taucherstraße 10','Cunewalde','1307','Germany\r'),(64,'Rancho grande','Sergio Gutiérrez','Av. del Libertador 900','Buenos Aires','1010','Argentina\r'),(65,'Rattlesnake Canyon Grocery','Paula Wilson','2817 Milton Dr.','Albuquerque','87110','USA\r'),(66,'Reggiani Caseifici','Maurizio Moroni','Strada Provinciale 124','Reggio Emilia','42100','Italy\r'),(67,'Ricardo Adocicados','Janete Limeira','Av. Copacabana, 267','Rio de Janeiro','02389-890','Brazil\r'),(68,'Richter Supermarkt','Michael Holz','Grenzacherweg 237','Genève','1203','Switzerland\r'),(69,'Romero y tomillo','Alejandra Camino','Gran Vía, 1','Madrid','28001','Spain\r'),(70,'Santé Gourmet','Jonas Bergulfsen','Erling Skakkes gate 78','Stavern','4110','Norway\r'),(71,'Save-a-lot Markets','Jose Pavarotti','187 Suffolk Ln.','Boise','83720','USA\r'),(72,'Seven Seas Imports','Hari Kumar','90 Wadhurst Rd.','London','OX15 4NB','UK\r'),(73,'Simons bistro','Jytte Petersen','Vinbæltet 34','København','1734','Denmark\r'),(74,'Spécialités du monde','Dominique Perrier','25, rue Lauriston','Paris','75016','France\r'),(75,'Split Rail Beer & Ale','Art Braunschweiger','P.O. Box 555','Lander','82520','USA\r'),(76,'Suprêmes délices','Pascale Cartrain','Boulevard Tirou, 255','Charleroi','B-6000','Belgium\r'),(77,'The Big Cheese','Liz Nixon','89 Jefferson Way Suite 2','Portland','97201','USA\r'),(78,'The Cracker Box','Liu Wong','55 Grizzly Peak Rd.','Butte','59801','USA\r'),(79,'Toms Spezialitäten','Karin Josephs','Luisenstr. 48','Münster','44087','Germany\r'),(80,'Tortuga Restaurante','Miguel Angel Paolino','Avda. Azteca 123','México D.F.','5033','Mexico\r'),(81,'Tradição Hipermercados','Anabela Domingues','Av. Inês de Castro, 414','São Paulo','05634-030','Brazil\r'),(82,'Trail\'s Head Gourmet Provisioners','Helvetius Nagy','722 DaVinci Blvd.','Kirkland','98034','USA\r'),(83,'Vaffeljernet','Palle Ibsen','Smagsløget 45','Århus','8200','Denmark\r'),(84,'Victuailles en stock','Mary Saveley','2, rue du Commerce','Lyon','69004','France\r'),(85,'Vins et alcools Chevalier','Paul Henriot','59 rue de l\'Abbaye','Reims','51100','France\r'),(86,'Die Wandernde Kuh','Rita Müller','Adenauerallee 900','Stuttgart','70563','Germany\r'),(87,'Wartian Herkku','Pirkko Koskitalo','Torikatu 38','Oulu','90110','Finland\r'),(88,'Wellington Importadora','Paula Parente','Rua do Mercado, 12','Resende','08737-363','Brazil\r'),(89,'White Clover Markets','Karl Jablonski','305 - 14th Ave. S. Suite 3B','Seattle','98128','USA\r'),(90,'Wilman Kala','Matti Karttunen','Keskuskatu 45','Helsinki','21240','Finland\r'),(91,'Wolski','Zbyszek','ul. Filtrowa 68','Walla','01-012','Poland\r');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `EmployeeID` int NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `BirthDate` date NOT NULL,
  `Notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  PRIMARY KEY (`EmployeeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (0,'','','0000-00-00',NULL),(1,'Davolio','Nancy','1968-12-08','Nancy es una veterana en ventas con más de una década de experiencia en el sector minorista. Su historial demuestra su capacidad para superar consistentemente las metas de ventas y liderar equipos hacia el éxito. Es conocida por su excelente habilidad de negociación y por mantener relaciones duraderas con los clientes.'),(2,'Fuller','Andrew','1966-02-19','Andrew ha trabajado en el área de gestión por más de quince años, especializándose en logística y operaciones. Ha implementado varios sistemas que han mejorado la eficiencia y reducido los costos operativos. Su experiencia en la optimización de procesos lo convierte en un activo invaluable para cualquier equipo.'),(3,'Leverling','Janet','1963-08-30','Janet se unió a la empresa después de una destacada carrera como consultora de negocios. Su experiencia abarca la planificación estratégica, el desarrollo de mercado y la gestión de proyectos de gran escala. A lo largo de los años, ha demostrado una gran capacidad para identificar oportunidades de crecimiento.'),(4,'Peacock','Margaret','1969-09-19','Margaret es una talentosa desarrolladora de software con ocho años de experiencia en la creación de aplicaciones de gestión de inventario. Su habilidad técnica y su enfoque en la resolución de problemas la han convertido en una figura clave en el departamento de tecnología. Ha liderado varios proyectos exitosos de desarrollo de software.'),(5,'Buchanan','Steven','1974-03-04','Steven tiene una vasta experiencia en finanzas, habiendo trabajado como analista financiero y gestor de carteras. Su enfoque meticuloso y su conocimiento profundo de los mercados financieros han sido cruciales para las decisiones de inversión de la empresa. Es un experto en el análisis de datos financieros complejos.'),(6,'Suyama','Michael','1971-07-02','Michael es un profesional de marketing con una década de experiencia en campañas digitales. Ha dirigido numerosas iniciativas de marketing que han incrementado la visibilidad de la marca y las ventas en línea. Su creatividad y conocimiento de las tendencias del mercado son inigualables.'),(7,'King','Robert','1960-05-29','Robert, con más de 25 años en el área de recursos humanos, es un experto en la gestión de personal, la formación y el desarrollo de talento. Su experiencia en la creación de políticas de recursos humanos y en la mediación de conflictos lo ha hecho muy respetado entre sus colegas.'),(8,'Callahan','Laura','1972-01-09','Laura es una especialista en soporte técnico con un historial de resolución de problemas complejos en tiempo récord. Su experiencia en el servicio al cliente y su paciencia la convierten en un punto de contacto confiable y eficaz. Ha entrenado a varios equipos de soporte para mejorar la satisfacción del cliente.'),(9,'Dodsworth','Anne','1980-04-03','Anne es una profesional de la comunicación con experiencia en relaciones públicas y gestión de medios. Ha gestionado con éxito la reputación de la empresa y ha cultivado relaciones sólidas con periodistas y otros medios de comunicación. Su experiencia es fundamental para la estrategia de comunicación corporativa.'),(10,'Jones','Matthew','1985-06-21','Matthew es un analista de datos con cinco años de experiencia en la industria tecnológica. Utiliza sus habilidades en análisis estadístico para identificar patrones y oportunidades de negocio. Su trabajo ha sido clave para mejorar la toma de decisiones basada en datos.'),(11,'Davis','Sarah','1977-11-12','Sarah es una diseñadora gráfica con una gran trayectoria en la creación de materiales de marketing visualmente atractivos. Su experiencia abarca desde el diseño de logotipos hasta la maquetación de sitios web. Su enfoque creativo y su atención al detalle son excepcionales.'),(12,'Miller','David','1988-02-25','David es un ingeniero de software con especialización en el desarrollo de aplicaciones móviles. Ha trabajado en numerosos proyectos, desde la ideación hasta la implementación, y es un experto en lenguajes de programación modernos. Su experiencia ha sido fundamental para la creación de la app de la compañía.'),(13,'Wilson','Emily','1991-09-07','Emily se ha destacado en el área de contabilidad, gestionando las finanzas de la empresa con gran precisión. Su experiencia en la auditoría y la preparación de estados financieros es un gran activo. Es muy valorada por su ética de trabajo y su atención a los detalles.'),(14,'Moore','James','1983-04-18','James es un gestor de proyectos con una sólida experiencia en la coordinación de equipos y la entrega de proyectos dentro del plazo y presupuesto establecidos. Ha liderado proyectos complejos en diversos sectores, demostrando una gran adaptabilidad y liderazgo.'),(15,'Taylor','Olivia','1989-10-31','Olivia es una especialista en marketing digital con un enfoque en la optimización para motores de búsqueda (SEO) y la gestión de contenido. Ha logrado aumentar significativamente el tráfico orgánico a la página web de la empresa. Su experiencia en el análisis de datos de marketing es notable.'),(16,'Anderson','Daniel','1970-01-28','Daniel es un arquitecto de sistemas con más de 20 años de experiencia. Ha diseñado e implementado la infraestructura tecnológica de varias organizaciones, asegurando la escalabilidad y seguridad de los sistemas. Su conocimiento técnico es profundo y valioso.'),(17,'Thomas','Sophia','1993-08-05','Sophia es una profesional de la experiencia del usuario (UX) con experiencia en el diseño de interfaces intuitivas y funcionales. Realiza investigaciones de usuarios y pruebas de usabilidad para garantizar que los productos satisfagan las necesidades del mercado.'),(18,'Jackson','William','1981-03-22','William es un analista de negocios con una gran capacidad para traducir las necesidades del negocio en requisitos técnicos. Ha trabajado en estrecha colaboración con equipos de desarrollo para asegurar la alineación entre la tecnología y los objetivos empresariales.'),(19,'White','Jessica','1975-06-14','Jessica ha pasado gran parte de su carrera en el área de operaciones, supervisando la cadena de suministro y la logística. Ha optimizado procesos para reducir costos y mejorar la eficiencia, lo que ha tenido un impacto directo en la rentabilidad.'),(20,'Harris','Christopher','1986-11-29','Christopher es un profesional de ventas con una destacada trayectoria en la adquisición de nuevos clientes. Es conocido por su enfoque proactivo y su habilidad para construir relaciones de confianza con los clientes clave.'),(21,'Martin','Linda','1967-02-15','Linda es una experta en recursos humanos con especialización en compensaciones y beneficios. Su experiencia en el diseño de programas de compensación competitivos y justos es fundamental para atraer y retener talento.'),(22,'Garcia','Carlos','1979-07-26','Carlos es un ingeniero de calidad de software con una sólida experiencia en la implementación de pruebas automatizadas. Ha mejorado los procesos de control de calidad y ha reducido la incidencia de errores en las aplicaciones.'),(23,'Rodriguez','Maria','1990-09-01','Maria es una gestora de redes sociales con experiencia en la creación de estrategias de contenido y la gestión de campañas publicitarias en plataformas sociales. Ha logrado aumentar la interacción con la audiencia de manera significativa.'),(24,'Lopez','Ricardo','1984-12-09','Ricardo es un desarrollador front-end con un talento especial para la creación de interfaces de usuario atractivas y responsivas. Es un experto en las últimas tecnologías web y trabaja en estrecha colaboración con los diseñadores.'),(25,'Martinez','Susan','1973-05-11','Susan es una contadora senior con experiencia en la preparación de presupuestos, pronósticos financieros y análisis de variaciones. Su atención al detalle y su precisión son muy valoradas en el equipo financiero.'),(26,'Hernandez','Juan','1992-04-20','Juan es un especialista en soporte de TI con experiencia en la resolución de problemas técnicos para empleados. Su capacidad para diagnosticar y solucionar problemas rápidamente lo convierte en un recurso indispensable.'),(27,'Gomez','Patricia','1982-10-06','Patricia es una gerente de producto con una trayectoria exitosa en el lanzamiento de productos al mercado. Combina sus habilidades de marketing, diseño y desarrollo para crear productos que satisfacen las necesidades de los clientes.'),(28,'Sanchez','David','1976-08-27','David es un experto en seguridad informática con experiencia en la protección de datos y la prevención de ciberataques. Realiza auditorías de seguridad y desarrolla planes de respuesta a incidentes para proteger los activos de la empresa.'),(29,'Diaz','Carolina','1994-03-16','Carolina es una analista de marketing digital con experiencia en el análisis de datos de campañas y el rendimiento del sitio web. Utiliza herramientas de análisis para proporcionar información valiosa que guía las decisiones estratégicas.'),(30,'Perez','Jorge','1987-11-03','Jorge es un desarrollador back-end con un profundo conocimiento en el diseño y la implementación de bases de datos. Su experiencia en la optimización del rendimiento de los servidores y en la construcción de APIs robustas es fundamental para los proyectos de la compañía.');
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_log`
--

DROP TABLE IF EXISTS `order_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_log` (
  `LogID` int NOT NULL AUTO_INCREMENT,
  `OrderID` int DEFAULT NULL,
  `ActionType` varchar(20) DEFAULT NULL,
  `ActionDate` datetime DEFAULT NULL,
  PRIMARY KEY (`LogID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_log`
--

LOCK TABLES `order_log` WRITE;
/*!40000 ALTER TABLE `order_log` DISABLE KEYS */;
INSERT INTO `order_log` VALUES (1,20001,'INSERT','2026-11-17 19:53:19');
/*!40000 ALTER TABLE `order_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `OrderID` int NOT NULL,
  `CustomerID` int DEFAULT NULL,
  `EmployeeID` int DEFAULT NULL,
  `OrderDate` date DEFAULT NULL,
  `ShipperID` int DEFAULT NULL,
  PRIMARY KEY (`OrderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (20001,90,5,'2025-10-23',3);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_order_insert` AFTER INSERT ON `orders` FOR EACH ROW BEGIN
    INSERT INTO order_log (OrderID, ActionType, ActionDate)
    VALUES (NEW.OrderID, 'INSERT', NOW());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `ProductID` int NOT NULL,
  `ProductName` varchar(100) NOT NULL,
  `SupplierID` int DEFAULT NULL,
  `CategoryID` int DEFAULT NULL,
  `Unit` varchar(50) DEFAULT NULL,
  `Price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (501,'Queso Manchego',12,4,'10 - 500 g pkgs',38.00);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-17 20:00:49
