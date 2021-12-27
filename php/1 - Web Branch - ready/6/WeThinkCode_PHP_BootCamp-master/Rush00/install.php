<?php
	function install_db()
	{
		$db_server = "localhost";
		$db_username = "root";
		$db_password = "bakcWO0I2BBhTF4X";
		$db_name = "rush00";

		$db_conn = mysqli_connect($db_server, $db_username, $db_password);
		if (!$db_conn)
		{
			echo "Failed to connect to MySQL Server";
			return false;
		}

		$db_create = "CREATE DATABASE IF NOT EXISTS " . $db_name;
		if (!mysqli_select_db($db_conn, $db_name))
		{
			mysqli_query($db_conn, $db_create);
			mysqli_select_db($db_conn, $db_name);
		}
		else
			return true;


		/*
		Creation of Users table and one admin.
		*/

		$db_create_users = "CREATE TABLE `rush00`.`users` ( `ID` INT NOT NULL AUTO_INCREMENT , `Level` VARCHAR(255) NOT NULL , `Title` VARCHAR(255) NOT NULL , `FirstName` VARCHAR(255) NULL , `LastName` VARCHAR(255) NOT NULL , `Username` VARCHAR(255) NOT NULL , `Passwd` VARCHAR(128) NOT NULL , `Email` VARCHAR(255) NOT NULL , PRIMARY KEY (`ID`)) ENGINE = InnoDB;";
		if (!mysqli_query($db_conn, $db_create_users))
		{
			echo "Failed to create users tables";
			mysqli_query($db_conn, "DROP DATABASE " . $db_name);
			return false;
		}

		$db_create_admin_1 ="INSERT INTO `users` (`ID`, `Level`, `Title`, `FirstName`, `LastName`, `Username`, `Passwd`, `Email`) VALUES (NULL, 'admin', 'Mr.', 'Owen', 'Exall', 'oexall', '6737878874ca74805b0c39865dcead55e7642e05f26b88b1d414a34fb62ab4e53da579989377a3f93a30d899dd384f51fbc0fad35aee70dbc38438196c689cc7', 'owen@exall.za.net')";
		if (!mysqli_query($db_conn, $db_create_admin_1))
		{
			echo "Failed to create Admin.";
			mysqli_query($db_conn, "DROP DATABASE " . $db_name);
			return false;
		}

		/*
		Creation of category table and addition of some categories
		*/

		$db_create_categories = "CREATE TABLE `rush00`.`categories` ( `ID` INT NOT NULL AUTO_INCREMENT , `Category` VARCHAR(255) NOT NULL , `Description` TEXT NOT NULL , PRIMARY KEY (`ID`)) ENGINE = InnoDB;";
		if (!mysqli_query($db_conn, $db_create_categories))
		{
			echo "Failed to create categories tables";
			mysqli_query($db_conn, "DROP DATABASE " . $db_name);
			return false;
		}

		$db_create_categories_add = "INSERT INTO `categories` (`ID`, `Category`, `Description`) VALUES (NULL, 'Phones', 'Phones, essential to a students way of life. Without it, they return to the ways of barbarism and cannibalism, caused by the lack of Hitchhikers Guide to the Galaxy.'), (NULL, 'Accessories', 'Essentials like earphones and chargers, because we wouldn\'t want the students want to go without their phones now would we...'), (NULL, 'Fast Food', 'Food for on the run, when that project deadline is nearing at a horrendous pace.'), (NULL, 'Proper Food', 'When that project deadline is a few weeks away on the horizon and you think you have time (where you actually don\'t).'), (NULL, 'Misc', 'All other objects of interest...');";
		if (!mysqli_query($db_conn, $db_create_categories_add))
		{
			echo "Failed to add Categories";
			mysqli_query($db_conn, "DROP DATABASE " . $db_name);
			return false;
		}

		/*
		Creation of the Items Table.
		*/

		$db_create_items_table = "CREATE TABLE `rush00`.`items` ( `ID` INT NOT NULL AUTO_INCREMENT , `Name` VARCHAR(255) NOT NULL , `Img_link` TEXT NOT NULL , `Price` DOUBLE NOT NULL , `Stock` INT NOT NULL , `Description` TEXT NOT NULL , PRIMARY KEY (`ID`)) ENGINE = InnoDB;";
		if (!mysqli_query($db_conn, $db_create_items_table))
		{
			echo "Failed to create Items Table";
			mysqli_query($db_conn, "DROP DATABASE " . $db_name);
			return false;
		}

		$db_add_items = "INSERT INTO `items` (`ID`, `Name`, `Img_link`, `Price`, `Stock`, `Description`) VALUES
(1, 'Apple IPhone 7', 'https://cdn.shopify.com/s/files/1/1488/7814/products/iphone7-black-select-2016_AV2_large.png?v=1473924089', 20999, 10, 'iPhone 7 dramatically improves the most important aspects of the iPhone experience. It introduces advanced new camera systems. The best performance and battery life ever in an iPhone. Immersive stereo speakers. The brightest, most colorful iPhone display. Splash and water resistance.1 And it looks every bit as powerful as it is. This is iPhone 7.\r\n\r\nP.s. Doesn\'t have a earphones jack...'),
(2, 'Galaxy Note 7', 'http://cdn2.gsmarena.com/vv/bigpic/samsung-galaxy-note7.jpg', 14000, 10, 'We rethought the Galaxy Note from every angle. A dual-curved screen so you can do more, better and faster. A rounded back so you can hold the 5.7-inch Note comfortably in the hand while using the S Pen. And continuing with the legacy of our previous Galaxy phones, we made the Galaxy Note7 water resistant. This time not just the device, but also the S Pen. So you can carry on using your phone wherever you are.'),
(3, 'Apple Earpods', 'https://ae01.alicdn.com/kf/HTB1SQuOLFXXXXXQapXXq6xXFXXXw/100-Genuine-in-Ear-earphone-with-Mic-Remote-Original-font-b-Earpods-b-font-For-font.jpg', 600, 10, 'Comes with remote and Mic, for those who chose to get a stipend but don\'t really need it.'),
(4, 'Galaxy Note 7 Charger', 'http://www.samsung.com/global/galaxy/galaxy-note7/accessories/images/galaxy-note7-accessories_kv.jpg', 1899, 5, 'The Samsung Note 7 charger, be careful though, it might go \'BOOM\'. Pretty cool charger though.'),
(5, 'Big Tasty', 'http://www.mcdonalds.co.za/sites/default/files/product/Big-Tasty.png', 52.5, 999, 'It’s back! The soft and fluffy seeded bun, the exquisite combination of two 100% beef patties and two slices of creamy cheese, with shredded lettuce, slivered onions and tomato, topped with our famous smokey sauce. Once you’ve tasted the Big Tasty® you’ll be a fan for life.'),
(6, 'MegaMac', 'http://www.mcdonalds.co.za/sites/default/files/product/Mega-Bigmac.png', 62.8, 999, 'It’s a Big Mac® but all grown up! The classic stacked bun with four 100% beef patties, a slice of cheese, shredded lettuce, onion, pickles, and the Big Mac® sauce we all know and love.'),
(7, 'The Tamale Breakfast', 'http://www.muggandbean.co.za/img/menu/start-03.jpg', 74.9, 999, 'From Mugg & Bean... What do you expect? Expect good quality.'),
(8, 'Backyard BBQ pretzel.', 'http://www.muggandbean.co.za/img/menu/fillings-04.jpg', 94.9, 999, 'From Mugg & Bean... What do you expect? Expect good quality.'),
(9, 'Community Service', '', 20, 999999, 'Donate to the WTC_ cause... We dare you...'),
(10, 'Cheese', '', 75, 5, 'Some cheese');
";
		if (!mysqli_query($db_conn, $db_add_items))
		{
			echo "Failed to add Items to table";
			mysqli_query($db_conn, "DROP DATABASE " . $db_name);
			return false;
		}


		/*
		Creation of assign_categories.
		*/

		$db_create_assign_categories = "CREATE TABLE `assign_categories` (`ID` int(11) NOT NULL, `Item_ID` int(11) NOT NULL, `Category_ID` int(11) NOT NULL , PRIMARY KEY (`ID`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;";
		if (!mysqli_query($db_conn, $db_create_assign_categories))
		{
			echo "Failed to create";
			mysqli_query($db_conn, "DROP DATABASE " . $db_name);
			return false;
		}

		$db_add_assign = "INSERT INTO `assign_categories` (`ID`, `Item_ID`, `Category_ID`) VALUES (1, 1, 3), (2, 2, 3), (3, 3, 4), (4, 4, 4), (5, 5, 5), (6, 6, 5), (7, 7, 6), (8, 8, 6), (9, 9, 7), (10, 10, 6), (11, 10, 7);";
		if (!mysqli_query($db_conn, $db_add_assign))
		{
			echo "Failed to add category assignments";
			mysqli_query($db_conn, "DROP DATABASE " . $db_name);
			return false;
		}

		$db_create_orders = "CREATE TABLE `rush00`.`orders` ( `ID` INT NOT NULL AUTO_INCREMENT , `user_id` INT NOT NULL , `user_order` TEXT NOT NULL , `placed` TEXT NOT NULL , PRIMARY KEY (`ID`)) ENGINE = InnoDB;";
		if (!mysqli_query($db_conn, $db_create_orders))
		{
			echo "Failed to create orders table";
			mysqli_query($db_conn, "DROP DATABASE " . $db_name);
			return false;
		}

		mysqli_close($db_conn);
		return true;
	}
?>