<?php
	date_default_timezone_set("Africa/Johannesburg");
	session_start();
	if ($_POST['modify'] == 'MODIFY')
	{
		$a_file = unserialize(file_get_contents("./private/basket"));
		foreach ($a_file as $key => $item)
		{
			if ($item['ID'] === $_POST['id'])
			{
				$i_qty = intval($_POST['qty']);
				$a_file[$key]['Qty'] = $i_qty;
				$a_file[$key]['Total'] = 0;
				for ($i = 1; $i <= $i_qty; $i++)
					$a_file[$key]['Total'] += $a_file[$key]['Price'];

			}
		}
		file_put_contents("./private/basket", serialize($a_file));
		header("Location: index.php?load=basket");
	}

	if ($_POST['remove'] == 'REMOVE')
	{
		$a_file = unserialize(file_get_contents("./private/basket"));
		foreach ($a_file as $key => $item)
		{
			if ($item['ID'] === $_POST['id'])
			{
				unset($a_file[$key]);
			}
		}
		file_put_contents("./private/basket", serialize($a_file));
		header("Location: index.php?load=basket");
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
	if ($_POST['clear'] === 'CLEAR ORDER' && $i_count > 0)
	{
		unlink('./private/basket');
		header("Location: index.php?load=basket");
	}
	if ($_POST['validate'] === "VALIDATE ORDER" && $i_count > 0)
	{
		

		if ($_SESSION['logged_on'] == null || $_SESSION['logged_on'] === "")
		{
			$_SESSION['From'] = "Basket";
			header("Location: index.php?load=login");
		}	

		$db_server = "localhost";
		$db_username = "root";
		$db_password = "bakcWO0I2BBhTF4X";
		$db_name = "rush00";

		$db_conn = mysqli_connect($db_server, $db_username, $db_password, $db_name);
		if (!$db_conn)
		{
			echo "Error Connection to database";
			return ;
		}

		$db_usr_id = mysqli_fetch_assoc(mysqli_query($db_conn, "SELECT ID FROM `users` WHERE Username='" . $_SESSION['logged_on'] . "';"));

		$db_add_order = "INSERT INTO `orders` (`ID`, `user_id`, `user_order`, `placed`) VALUES (NULL, '" . $db_usr_id['ID'] . "', '" . file_get_contents("./private/basket") . "', '" . date("Y-m-d H:i") . "')";
		if (!mysqli_query($db_conn, $db_add_order))
		{
			echo "Order Failed";
			return ;
		}
		unlink("./private/basket");
		mysqli_close($db_conn);
		header("Location: index.php");
	}
	if (($_POST['clear'] === 'CLEAR ORDER' || $_POST['validate'] === "VALIDATE ORDER") && $i_count <= 0)
		header("Location: index.php");
?>

<!DOCTYPE html>
<html>
	<head>
		<style type="text/css">
			h1, table {
				color: #bdbdbd;
			}
		</style>
	</head>
	<body>
		<h1>Complete Basket:</h1>
		<table>
			<tr>
				<td width="190px">ITEM NAME</td>
				<td width="125px">PRICE</td>
				<td width="34px">Qty</td>
				<td>TOTAL</td>
			</tr>
		</table>
		<?php

		if (file_exists("./private/basket"))
		{
			$a_file = unserialize(file_get_contents("./private/basket"));
			foreach ($a_file as $item)
			{
				echo "<form target='_top' action='basket.php' method='POST' style='margin-bottom:10px;'>";
					echo "<input name='id' type='hidden' value='" . $item['ID'] . "' />";
					echo "<input size='30' name='name' type='input' readonly='true' value='" . $item['Name'] . "'/>";
					echo "<input name='price' type='input' readonly='true' value='R" . $item['Price'] . "'/>";
					echo "<input name='qty' type='input' value='" . $item['Qty'] . "' size='5' />";
					echo "<input name='total' type='input' readonly='true' value='R" . $item['Total'] . "' />";
					echo "<input name='modify' type='submit' value='MODIFY'/>";
					echo "<input name='remove' type='submit' value='REMOVE' />";
				echo "</form>";
			}
		}
		else
			echo "<br/><h1>No Items in Basket... (Please add some)</h1>";

		?>
		<form target="_top" action="basket.php" method="POST">
			<input type="submit" name="validate" value="VALIDATE ORDER"/>
			<input type="submit" name="clear" value="CLEAR ORDER"/>
		</form>
	</body>
</html>