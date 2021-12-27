CREATE TABLE IF NOT EXISTS `ft_table` (
  `id` int NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `login` varchar(8) NOT NULL DEFAULT 'toto',
  `groupe` enum('staff','student','other') NOT NULL,
  `date_de_creation` date NOT NULL
);
