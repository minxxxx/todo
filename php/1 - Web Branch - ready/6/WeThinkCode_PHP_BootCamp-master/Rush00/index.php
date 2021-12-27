<?php
	include("install.php");
	if (install_db() == false)
	{
		echo "Install Failed.";
		return ;
	}
	session_start();

	$s_username = $_SESSION['logged_on'];
	$i_access = $_SESSION['access_level'];

	$s_load = $_GET['load'];
	$s_cat = $_GET['cat'];

	$db_server = "localhost";
	$db_username = "root";
	$db_password = "bakcWO0I2BBhTF4X";
	$db_name = "rush00";

	if ($_POST['add_trolly'] == "ADD")
	{
		$s_id = $_POST['item_id'];
		$s_name = $_POST['it_name'];
		$s_price = $_POST['item_price'];

		$a_item = array();
		$a_item['ID'] = $s_id;
		$a_item['Name'] = $s_name;
		$a_item['Qty'] = 1;
		$a_item['Price'] = $s_price;
		$a_item['Total'] = doubleval($s_price);

		$a_file;
		$has_item = false;
		if (!is_dir("./private"))
			mkdir("./private");
		if (file_exists("./private/basket"))
		{
			$a_file = unserialize(file_get_contents("./private/basket"));
			foreach ($a_file as $key=>$item)
			{
				if ($item['ID'] === $a_item['ID'])
				{
					$has_item = true;
					$a_file[$key]['Qty'] += 1;
					$a_file[$key]['Total'] += $a_item['Price'];
				}
			}
			if ($has_item === false)
				$a_file[] = $a_item;
			file_put_contents("./private/basket", serialize($a_file));
		}
		else
		{
			$a_file = array();
			$a_file[] = $a_item;
			file_put_contents("./private/basket", serialize($a_file));
		}
	}

	$i_count = 0;
	if (file_exists("./private/basket"))
	{
		$a_file = unserialize(file_get_contents("./private/basket"));
		foreach ($a_file as $item)
		{
			$i_count += $item['Qty'];
		}
	}
?>

<!DOCTYPE html>
<html lang="en" class="no-js">

<head>
	<meta charset="UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>WTC_ Shop</title>
	<meta name="description" content="WeThinkcode PHP_BootCamp Rush_00 Project." />
	<meta name="keywords" content="Making a mini e-commerce online shop" />
	<meta name="author" content="ggroener and oexall" />
	<link rel="shortcut icon" href="favicon.ico">
	<!-- food icons -->
	<link rel="stylesheet" type="text/css" href="css/organicfoodicons.css" />
	<!-- index styles -->
	<link rel="stylesheet" type="text/css" href="css/index.css" />
	<!-- menu styles -->
	<link rel="stylesheet" type="text/css" href="css/component.css" />
	<!--Used for icons -->
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="http://www.w3schools.com/lib/w3.css">
	<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
	<!-- dropdown function -->
	<script src="js/dropdown.js"></script>
	<script src="js/js-custom-lib.js"></script>
</head>

<body>
	<!-- Main container -->
	<div class="container">
		<!-- Webheader header -->
		<header class="bp-header cf">
			<div class="place-logo">
				<div class="placeholder-icon foodicon foodicon--coconut"> <a href="index.php"> <img class="logo_img" src="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxAQEhAQEBMQEQ8VEQ4YEA8PDhERDhIPFBUWFhUSFRYYHTQgGRolGxMWIj0hJSkrLi4uFx86OjMtQyguLisBCgoKDg0OGxAQGi0dIB0tLSswLS0tLS0tMC0tLS0tKy0tLS0tLS0tLSstLSstLy0tLS0tLS8tKy0tLS0rLS0tLf/AABEIAKkBKwMBEQACEQEDEQH/xAAbAAEAAgMBAQAAAAAAAAAAAAAABAUBAgMHBv/EAEQQAAIBAgIHAwcLAgQHAQAAAAABAgMRBDEFEiFRYXGBE0GRFCIyU5Ox0gYHIzNCQ4KSlKHTUnJUc8LxFqKjssHR8BX/xAAYAQEAAwEAAAAAAAAAAAAAAAAAAQIDBP/EAC0RAQACAQMDAgYABwEAAAAAAAABAhEDEjEhQVETIiNCUnGBoQQyU2GxwfAU/9oADAMBAAIRAxEAPwDw4AAAAAAAAAAAAAAAAAAAAADaFNvJN77Lu3kxEyiZiGrRCQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMpXEErZ13hoQ1bdpPbNNXXY3tqNbpNO63RW82tOyIiGFY3zMzw4aSw8fNq079nNXjfNb4Pins8H3i8RMboTp2mJ2yrzFsAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAM6r3PwJwjMGq9z8BiTMJ2isNrSvO6hFOU3bKEdr693No006957MtW3yx3RsZiHVnKbVrvYllGK2RiuCSS6GdpmZy0rEVjCToyuttGo7U55Sb2Qqd0uTyfCz7i+nbHSeJU1K56xzCNisPKnJxaaabTW5ruIvXbK1LxaHEouAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAzHNc0THKJS7GzBvFXJhE9E3SEuzpRpL0p6sqnCC9CPV+d0iW1JxG1TRjMzefwqTF0AFrOfa0VOXpwkoOT+2krp84qyfOO9m0TmvXswmNt+ndSHK6wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGY5rmiY5RKYkbME7RlFNuc9lOKcpvv1V3Li3ZLi0aU6e6WOpOfbHdBxVd1JynLOTvZZJd0VwSsuhjM5nLorERGIcCFm1ODk1GKvJtKKWbk3ZICy0lJQUaMHeMFa6ylN7Zz6v9kja3tja56e625SnK7AAAAAAAAAAAAAAAAAAAAAAAAAAAAGyg9z8GTiUZg7OW5+DG2TdHk7N7n4MYk3R5YcXufgMGYLEYTksDLMVtXNExyieE2Ebs3iMueZxCbpGfZ04UV6UtWdTl93D/V1iW1Jx7VNKM5vKqZi3AlcfJ7CX16zeqoqUYyeSlq3nP8MP3ktxto1zm08Q59e+MUjmyLpDDuEs9aLs4yWUoPbGXVNEXjunTnt4Vdnx8Dmw68lnx8BgywAAAAAAAAAAAAAAAAAAAAAAAAAAFhSyjyXuOmvDltzLYlVixCUWtm+nuMrct6cNSqwB0jkaRwpPKfoylG7qT+rgnKW9pZRXFtpdTSnSN09mGpM2nbHdBr1pVJSnL0pNt7rvuXDuMc56t4iIjENANqVOU5RhFXlJpRW+Tdkgccr/AE5VjQoww0He8VrPfTTu3+Oab5RW86dX2VjTj7y5ND4l51Z+0IWCl2tJ0n6dNOVPe6Td5R6N35SluKac5ja01Y2zvj8oTjYpjC+csAR8Rn0Mr8tqcORVcAAAAAAAAAAAAAAAAAAAAAAAALClkuS9x014ctuZbEqsNBMI1bN9PcY25b04aFVgDrTjeyNKxlnacJ+kp9nCFBZvVnV6r6OPg9b8S3F9Sce3wz0Yzm891YZNmQhe/JrDJKeJnshFSUX3rZ58lxUXqrjPgdGhWIzeeI/y5v4m0zjTrzb/AAqcXiJVZzqS2OTyWUVlGK4JJLoYzM2nMt4iKxER2YoVZU5RnD0ou6vk+D4NXXJkcdYOk9JT9I0Y+bUh9XNa0d6WTi+Kaa6G1ozG6GFJmszWeyCzNqjYjPoZX5bU4ciq4AAAAAAAAAAAAAAAAAAAAAAAAT6S2LkvcdFY6Oa09ZdLFlGLARay2vp7jK3LopPRpYrhbJYYMrPRVJK9Wa8yC1pLftso9W0upvT2xulzanuttjug1qspylOW2Um3J8XtZi3jp0aAb0KMpyjCKvKTSW67ffwJxMomYjrK+0vNRw8KdL6qM1GcrbWktaLfCUteXNI6NX20iscf7cmj79S1557fZQmDpbIIWGi568ZUHm7ypf3286P4kvGK3mmnPyz3Z6sfNHZCqwabRW0YWrMTCJXz6GN+W9OHMquzYGSwMsWAAAAAAAAAAAAAAAAAAAAAAAdKGb5F6cqX4dy7MA2j39PeTCJZpwuyYjMotOITdKz1IwoLNWnV/va82PSLvznwJ1Z+Xwpox8091XURlMN4lzKrrTR0ezpzrP0pa0KXK30kvB6v4pbjbTjHuYas5mKs6NxCblCp6E4uM96Ta85cU0nzRak7sxPdTUrtxaOyJiKTpylCXpRdnbJ7muDW3qZ8TiW0dYzDlrEZThmM2mpJtNWaae1NO6aBhZY9KpGNeKS1r68VlGqvTjbdtTXCSNp91dzCvsttVxk2azyInhaOWhRYAxLJiUuZVIAAAAAAAAAAAAAAAAAAAADpQzfIvTlS/DuXZgGY9/T3kwiVjo2CipVZq8YK9nlKWUYdXbpfcaV9sbmN/dbbDlQ0diMRepCnVq3lLWnGnKSc3teSz2/uVilrRlpOpWs4a4zROIpx1qlGrCOzzp05Rj4tEWpaI4TXUrM9JQ8NhZVJxpwV5SaUf/b4LPoZxWZnENZtERmeyz07QnScIOE6dOMdWnrwcXKKzltWbbbfGRtqRNYiHPpWi8zbug4DDVKstWlCc5Wvqwi5O11tsilImZ6NbzER1XWP0HiqlKNR0KynTSjK9Kd5U/svLOL2cmtxrqadp6sNLVrWduVBSoynJQjFym3ZRim5N7kkYREzOHTMxEZl3eja6n2TpVO1auqfZy12s72tfuLbLZxhX1K4zlIwGtTnLD1U4a9k1NOLhV+xJp5Z25Sv3E1nbbE91LxvrmvZFxFJwk01ZpvY8xaMSmlt0OE8ik8NY5aFFgDEsmJHMqsAAAAAAAAAAAAAAAAAAAAA6UM3yL05Uvw7mjMA6UIXduXvLVjKl5wmaWnqKFBfZtKp/mNbI/hi/GUidSfl8I0Y6bp7vRPm8rujozE14pOVOWIlFSvqtxpwaTsbU/lhhePfKTpDSMsZoetiKkYRlKM1qwTUVqzSWbYzmPwjbi0fd8b83ejdfEUpNbZSlq8KcPOnLq0ofmM9CvzS1/ibZxSH1nzsaNUsLTrR29nVcW13KV4y/wCaKRfV61U0cRZ8580FO+Mnf1E/++Blo9Mtdfrh6rgfKJyrOp5P5OpVY0XS7Ttrwm42qX2X815G84hz9ZeQaJw2ppinHY4vEOUJL0ZQk2017uaZlEY1ZbzO7Rh6fpPAQovF42Me0rxoJKHeoxjrfve/KJtlz47PB8XXlVnOpNtzlJuTfe3mcdpm05l30iKxiFhXfbU1V+8jaNXe5W82f4kvGMjSJ3V/vDHGy/8AaVXMylvVoVXAMSyIkcyqwAAAAAAAAAAAAAAAAAAAAAAA6IsqsdGRUFKtJJqCuk8pTfoR6v8AZM2p7Y3MNT3TFVbUqOTcpO8m223m29rZi3w9L+b/AE3g6eCq4bFVYxU51VKD1k3CUYrY0uDOzTmNsdXDq1tvmcLLSelNHeRTwODqx8+6hHz5WvJSlJtrJJN9C3TGIU92czCo+ROl8Lh69SpVmqcIU4woqSbepfa9nf5u3jJiu2Iwi0Wmd3lb4rT+DrYCrSdVKrUVabhLWb7aU3Oy2f1F8xPVTEx0w+a+b7SVLDYiU6slCLpSSbva+tF22cjPT75a6uekwvsD8pqE1pDDVqijSqVq0qM3rZTb2rZ3NRfVmkWjP2ZTWcccvmvk5iYeUUZTkk6FRyjPa70vtr/V0lvM4xNs+Gs5rXHl9V/xpQjj6n0ieFqUKcZTs9VVYXtdW3Nrqi26ucI2WmucdXmGmqdKNeqqMlOlrt05K9tV7Utu69uhyamN04dulM7IyzorEqnLzvq5Jxqf2t+lzTSfS3eKW2zk1Kbow3x+GdObi+592XNcC964lnp2zCMUaOFXMzty0rw0KrAAAAAAAAAAAAAAAAAAAAAAEjBYZ1Jxis20lzZeld0qal9sJc8RhotxVOpNJ2U+2jFSt9pLU2J7rlt9Y7Kenae7KxdD1M/1Ef4y3qR9Kk6c/UkUNNUoRcew1o3T1Z1Kc1rJWT86lxfiWjVjvWJROhbtaYdP/wB2h/hKfhQ/hJ9av0Qj0L/1JbR07R/wlP8A6H8JPrV+iFZ0L/1JZenqW3Vw0YXTTcJ0oSs81dUrj1ojikQf+e083mUR4+i/uZ/qI/xlfVjwtGjP1OkcfQsvoZ/qI7/8svGrHhSdGc/zNvLqPqZ/qI/xj1Y8I9GfqPLqD+5n+oj/ABj1I8J9Gfqb4XSFGNSL1J09q8/toyUd0nHU2pbriNWIngnRma8o2nMD2NRpK0JXcFmlvhfg9nKz7ymrTZbDTR1N9d3fuqpGLohtHIlEram+2o2+8pJJ75Ucov8AC/N5OJtSd1dvhzXjbbd2lXNFG0OFbMyvy0rw0KrAAAAAAAAAAAAAAAAAAAAANlTb/wB0TtlG6FpTg6NFzyqVNaEOEbfSS8Go/ie42mJrXHeWETF757QrLGWG2WyJQw4ghrYhLeJZEtrBBYDpFZf/AHeWhSWSUMgcqk9uRWZXrHRf4J+V4Z0ntr0ram9rKPivM5qBvWfU09vevH2c149LV3drc/d83JnM7G0ciUSkYLEulOM7XW1Sj/VB7JR6r/wTWZicwpasWjEpOksOoyvHbCSThK1rwe1M1vHeO7LTt2nsrK2Zz25dNeGhVYAAAAAAAAAAAAAAAAAAAABY6Mw7qShFd9s8ub4HRpVy5ta2IbaRxKqTbj9XFKNP+xZPm23L8RFrbpymlNsYQ3mU7tOzOsSjDZkoaFUiA3uWVLgZTJQjyzfNmbaGABAnaNxjo1I1FdpbJxX2oP0lz71xSNKXmlotHZlekXrNZ7p/ykwajNVobadXbdZa7V2+CkmpdWu401qxE7q8T1Z/w95mu23NeimMW7dEqrPAT7WnKi/ShrSp8YZzh09L85rpzmNssdWMTvj8oEo2dmUmMLxOYQ5ZvmzGeXRHDBCQAAAAAAAAAAAAAAAAAAALHR2MVO91GSlBxak5LZLY7arTTtdcmzaloiMSw1KTM5hJVfDeph7Sv8Zp8P8A6WXxf+hrLEYe/wBRD2lf4yJ9PwtHq+WPKMP6iHtK/wAY+H4Pi+W/bYf1EPaV/jJxp+Ffi+f0dth/UQ9pX+MY0/B8Xz+hVsP6iHtK/wAYxp+DOr5/TftcP6mHtK/xlsaaudXz+jtcP6mHtK/xjGmZ1fP6ZVXD+ph7Sv8AGMaaM6vn9I0sRh7v6CH56/xmfw/DaPV8nlOH9RD89f4yM6fhONXyeU4f1EPz1/jGdPwY1fLp2+H9RD2lf4y+NPwp8Xz+kuljIVYLDuMadOzUWnN6srtxk3JvYm30lItGLV2QzndW2+fyo6kHFuMlaUW1JPNSTs0c7rESh0oVpQlGcXaUWmnxW/gMzyiYzGJT9JUYvVq019HNXS/peTg+Kaa/3Nre6N0Oek7Z2ypZZvmzlnl2xwwQkAAAAAAAAAAAAAAAAAAADK7hBLqi7OS5IJBLqWZgBEodbFlSwBICLLN82Yzy6I4YAEDqaM2YSs7kxOEWjMLGq6Fa06kqkKmqlJwjGSlbYpbXsdrLoXmK2nOcMq2tSMYywsHhvW1fZw+IenXyerb6WfJMN62r7KHxD048nq2+l0lKjClOnGVSd5KUdaEYqMspZPvVvyonEVieqszN5icYUE83zZyzy7Y4YISAAAAAAAAAAAAAAAAAAAAAzcZMFxkwXGTBcBcBcBrPe/EnMoxBrPe/EZkxBrPe/EZkxDFyElwFwAAABm4C4C4GAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB//Z"> </a> </div>
				<h2 class="left-top-header">Left TOP Header</h2>
			</div>
			<div class="index-header__main">
				<span class="index-header__present"><?php echo ($s_username != null && $s_username != 'Guest') ? $s_username : "Guest"; ?><span class="bp-tooltip index_icon bp-icon--about" data-content="The user information goes here."></span></span>
				<h1 class="index-header__title">Welcome to DARK!
					<div class="no_items" style="position: relative; z-index: 20;">
							<div class="dropdown" style="position: relative; z-index: 20;">
								<button onclick="myFun_dropdown()" class="dropbtn"><?php echo $i_count; ?></button>
  							<div id="myDropdown" class="dropdown-content">
    							<a href="#item1">item1</a>
    							<a href="#item2">item2</a>
    							<a href="#item3">item3</a>
  						</div>
						</div>
					</div>
				</h1>
				<nav class="bp-nav">
					<a class="index-nav__item index_icon index-header__icon--basket" href="index.php?load=basket" data-info="Basket"><i class="material-icons">add_shopping_cart</i><span>Basket</span></a>
					<a class="index-nav__item index_icon index-header__icon--settings" href="index.php?load=settings" data-info="Settings"><i class="material-icons">build</i><span>Settings</span></a>
					<a class="index-nav__item index_icon index-header__icon--login" href="<?php echo ($s_username != null) ? 'logout.php' : 'index.php?load=login'; ?>" data-info="<?php echo ($s_username != null && $i_access > -1) ? 'Logout' : 'Login';?>"><i class="material-icons">account_circle</i><span>Logout</span></a>
				</nav>
			</div>
		</header>
		<button class="action action--open" aria-label="Open Menu"><span class="icon icon--menu"></span></button>
		<nav id="ml-menu" class="menu">
			<button class="action action--close" aria-label="Close Menu"><span class="icon icon--cross"></span></button>
			<div class="menu__wrap">
				<ul data-menu="main" class="menu__level">
					<li class="menu__item"><a class="menu__link" data-submenu="submenu-1" href="#">Electronics</a></li>
					<li class="menu__item"><a class="menu__link" data-submenu="submenu-2" href="#">Food Items</a></li>
					<li class="menu__item"><a class="menu__link" data-submenu="submenu-3" href="index.php?load=items&cat=misc">Misc.</a></li>
					<?php
						if ($i_access === 1)
							echo "<li class=\"menu__item\"><a class=\"menu__link\" data-submenu=\"submenu-4\" href=\"index.php?load=admin\">Admin</a></li>";
					?>
				</ul>
				<!-- Submenu 1 -->
				<ul data-menu="submenu-1" class="menu__level">
					<li class="menu__item"><a class="menu__link" href="index.php?load=items&cat=Phones">Phones</a></li>
					<li class="menu__item"><a class="menu__link" href="index.php?load=items&cat=Accessories">Accessories</a></li>
				</ul>
				<!-- Submenu 2 -->
				<ul data-menu="submenu-2" class="menu__level">
					<li class="menu__item"><a class="menu__link" href="index.php?load=items&cat=FastFood">Fast Food</a></li>
					<li class="menu__item"><a class="menu__link" href="index.php?load=items&cat=Food">Proper Food</a></li>
				</ul>
			</div>
		</nav>
		<div class="content">
			<?php
				if ($s_load === 'login' && $_SESSION['logged_on'] == null)
					echo "<iframe name=\"usr_login\" src=\"login.php\" height=\"500px\" width=\"100%\" frameborder=\"0\"></iframe>";
				elseif ($s_load === 'settings')
					echo "<iframe name=\"usr_login\" src=\"settings.php\" height=\"500px\" width=\"100%\" frameborder=\"0\"></iframe>";
				elseif ($s_load	=== 'admin' && $i_access === 1)
					echo "<iframe name=\"usr_login\" src=\"admin.php\" height=\"900px\" width=\"100%\" frameborder=\"0\"></iframe>";
				elseif ($s_load === 'basket')
					echo "<iframe name=\"usr_login\" src=\"basket.php\" height=\"500px\" width=\"100%\" frameborder=\"0\"></iframe>";
				else if ($s_load === 'items' && $s_cat != null && $s_cat !== "")
				{
					echo "<ul class='products'>";

					$db_conn = mysqli_connect($db_server, $db_username, $db_password, $db_name);
					if (!$db_conn)
					{
						echo "Error Connection to database" . mysqli_connect_error();
						return ;
					}

					$db_select = "SELECT * FROM `items` INNER JOIN `assign_categories` ON `items`.`ID` = `assign_categories`.`Item_ID` INNER JOIN `categories` ON `assign_categories`.`Category_ID`=`categories`.`ID` WHERE `categories`.`Category`='" . $s_cat . "';";
					$db_result = mysqli_query($db_conn, $db_select);
					if ($db_result)
					{
						while ($row = mysqli_fetch_assoc($db_result))
						{
							echo "<li class='product' style='text-align:center;'>";
							echo  "<div class='item_name'>" . $row['Name'] . "</div><br/>";
							echo "<img class='product_img' src='" . (($row['Img_link'] === "") ? "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1000px-No_image_available.svg.png" : $row['Img_link']) . "' />";
							echo "<div class='price_placement'><p class='price'>R" . $row['Price'] . "</p>";
								echo "<form class='trolly' action='" . $_SERVER['REQUEST_URI'] . "' method='POST'>";
									echo "<input type='hidden' name='item_id' value='" . $row['ID'] . "'/>";
									echo "<input type='hidden' name='it_name' value='" . $row['Name'] . "' />";
									echo "<input type='hidden' name='item_price' value='" . $row['Price'] . "'/>";
									echo "<input type='submit' name='add_trolly' value='ADD' />";
								echo "</form>";
							echo "</div></li>";
						}
					}
					mysqli_free_result($db_result);
					mysqli_close($db_conn);

					echo "</ul>";
				}
				elseif ($s_load !== 'items')
				{
					echo "<ul class='products'>";

					$db_conn = mysqli_connect($db_server, $db_username, $db_password, $db_name);
					if (!$db_conn)
					{
						echo "Error Connection to database" . mysqli_connect_error();
						return ;
					}

					$db_result = mysqli_query($db_conn, "SELECT * FROM `items`");
					if ($db_result)
					{
						while ($row = mysqli_fetch_assoc($db_result))
						{
							echo "<li class='product' style='text-align:center;'>";
							echo  "<div class='item_name'>" . $row['Name'] . "</div><br/>";
							echo "<img class='product_img' src='" . (($row['Img_link'] === "") ? "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1000px-No_image_available.svg.png" : $row['Img_link']) . "' />";
							echo "<div class='price_placement'><p class='price'>R" . $row['Price'] . "</p>";
								echo "<form class='trolly' action='index.php' method='POST'>";
									echo "<input type='hidden' name='item_id' value='" . $row['ID'] . "'/>";
									echo "<input type='hidden' name='it_name' value='" . $row['Name'] . "' />";
									echo "<input type='hidden' name='item_price' value='" . $row['Price'] . "'/>";
									echo "<input type='submit' name='add_trolly' value='ADD' />";
								echo "</form>";
							echo "</div></li>";
						}
					}
					mysqli_free_result($db_result);
					mysqli_close($db_conn);

					echo "</ul>";
				}
			?>
		</div>
	</div>
	<!-- /view -->
	<script src="js/classie.js"></script>
<!--	<script src="js/placeholder_data.js"></script> -->
	<script src="js/main.js"></script>
	<script>
	(function() {
		var menuEl = document.getElementById('ml-menu'),
			mlmenu = new MLMenu(menuEl, {
				// breadcrumbsCtrl : true, // show breadcrumbs
				// initialBreadcrumb : 'all', // initial breadcrumb text
				backCtrl : false, // show back button
				// itemsDelayInterval : 60, // delay between each menu item sliding animation
				//onItemClick: load_placeholder_Data // callback: item that doesn´t have a submenu gets clicked - onItemClick([event], [inner HTML of the clicked item])
			});

		// mobile menu toggle
		var openMenuCtrl = document.querySelector('.action--open'),
			closeMenuCtrl = document.querySelector('.action--close');

		openMenuCtrl.addEventListener('click', openMenu);
		closeMenuCtrl.addEventListener('click', closeMenu);

		function openMenu() {
			classie.add(menuEl, 'menu--open');
		}

		function closeMenu() {
			classie.remove(menuEl, 'menu--open');
		}

		// simulate grid content loading
		var gridWrapper = document.querySelector('.content');

		function load_placeholder_Data(ev, itemName) {
			ev.preventDefault();

			closeMenu();
			gridWrapper.innerHTML = '';
			classie.add(gridWrapper, 'content--loading');
			setTimeout(function() {
				classie.remove(gridWrapper, 'content--loading');
				gridWrapper.innerHTML = '<ul class="products">' + Placeholder_Data[itemName] + '</ul>';
			}, 700);
		}
	})();
	</script>
</body>

</html>
