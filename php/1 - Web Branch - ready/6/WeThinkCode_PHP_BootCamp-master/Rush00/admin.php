<?php
	session_start();

	if ($_SESSION['access_level'] != 1 || $_SESSION['logged_on'] == null)
	{
		echo "Place for Admin's only. Please leave this page!";
		return ;
	}

	$db_server = "localhost";
	$db_username = "root";
	$db_password ="bakcWO0I2BBhTF4X";
	$db_name = "rush00";


	if ($_POST['modify'] === 'Modify')
	{
		$s_id = $_POST['id'];
		$s_username = $_POST['login'];
		$s_access = $_POST['access'];

		$db_conn = mysqli_connect($db_server, $db_username, $db_password, $db_name);
		if (!$db_conn)
		{
			echo "Error Connection to database";
			return ;
		}

		$db_update = "UPDATE `users` SET Username='" . $s_username . "', Level='" . (($s_access === 'admin') ? "admin" : "member") . "' WHERE ID=" . $s_id . ";";
		
		if (!mysqli_query($db_conn, $db_update))
			echo "Failed to Update User.";
		else
			echo "Successfully Updated User";

		mysqli_close($db_conn);
	}
	if ($_POST['add'] == 'ADD')
	{
		$s_item = $_POST['item'];
		$s_img = $_POST['img'];
		$s_cat = $_POST['category'];
		$s_price = $_POST['price'];
		$s_stock = $_POST['stock'];
		$s_des = $_POST['description'];		


		$db_conn = mysqli_connect($db_server, $db_username, $db_password, $db_name);
		if (!$db_conn)
		{
			echo "Error Connection to database";
			return ;
		}


		$db_add = "INSERT INTO `items` (`Name`, `Img_link`, `Price`, `Stock`, `Description`) VALUES ('" . $s_item . "', '" . $s_img . "', '" . $s_price . "', '" . $s_stock . "', '" . $s_des . "')";
		if (!mysqli_query($db_conn, $db_add))
		{
			echo "Failed to add product.";
			return ;
		}

		$db_get_id = "SELECT ID FROM `items` WHERE Name='" . $s_item . "' AND Img_link='" . $s_img . "' AND Price='" . $s_price . "';";
		$db_get_cat = "SELECT ID FROM `categories` WHERE Category='" . $s_cat . "';";

		$db_item_ite_res = mysqli_fetch_assoc(mysqli_query($db_conn, $db_get_id));
		$db_item_cat_res = mysqli_fetch_assoc(mysqli_query($db_conn, $db_get_cat));

		$db_assoc_query = "INSERT INTO `assign_categories` (`ID`, `Item_ID`, `Category_ID`) VALUES (NULL, '" . $db_item_ite_res['ID'] . "', '" . $db_item_cat_res['ID'] . "');";
		if (!mysqli_query($db_conn, $db_assoc_query))
		{
			echo "Failed to Add Category";
			return ;
		}
		mysqli_free_result($db_item_ite_res);
		mysqli_free_result($db_item_cat_res);

		mysqli_close($db_conn);
	}
	if ($_POST['remove_item'] == "REMOVE")
	{
		$s_id = $_POST['id'];

		$db_conn = mysqli_connect($db_server, $db_username, $db_password, $db_name);
		if (!$db_conn)
		{
			echo "Error Connection to database";
			return ;
		}

		$db_remove = "DELETE FROM `items` WHERE ID='" . $s_id . "';";
		mysqli_query($db_conn, $db_remove);
		mysqli_close($db_conn);
		header("Location: index.php?load=admin");		
	}
	if ($_POST['modify_item'] == 'MODIFY')
	{
		$s_id = $_POST['id'];
		$s_name = $_POST['ite_name'];
		$s_price = $_POST['ite_price'];
		$s_stock = $_POST['ite_stock'];

		$db_conn = mysqli_connect($db_server, $db_username, $db_password, $db_name);
		if (!$db_conn)
		{
			echo "Error Connection to database";
			return ;
		}

		$db_update = "UPDATE `items` SET Name='" . $s_name . "', Price='" . $s_price . "', Stock='" .$s_stock . "' WHERE ID='" . $s_id ."';";
		mysqli_query($db_conn, $db_update);
		mysqli_close($db_conn);
		header("Location: index.php?load=admin");
	}
?>

<!DOCTYPE html>
<html>
	<head>
		<style type="text/css">
			h1, h3, label, table {
				color: #bdbdbd;
			}

			.userModif {
				width: 100%;
				max-height: 200px;
				overflow-y: auto;
			}

			input[type=submit] {
			    color:black;
			}
		</style>
	</head>
<body>
	<h1>Users</h1>
	<ul>
		<li><h3>Delete User</h3>
		<form action="admin.php" method="POST">
			<label for="login">Username:</label>
			<input type="input" name="login" required="true" />
			<input type="submit" name="delete" value="Delete"/>
		</form></li>
		
		<§li>
			<h3>Modify Users</h3>
			<div class="userModif">
			<?php

				$db_conn = mysqli_connect($db_server, $db_username, $db_password, $db_name);
				if (!$db_conn)
				{
					echo "Error Connection to database";
					return ;
				}

				$db_query = "SELECT * FROM `users`";
				$db_result = mysqli_query($db_conn, $db_query);
				if ($db_result)
				{
					while ($row = mysqli_fetch_assoc($db_result))
					{
						echo "<form action='admin.php' method='POST' style='margin-bottom:10px;'>";
						echo "<label for='id'>ID:</label>";
						echo "<input type='input' readonly='true' name='id' size='6' value=\"" . $row['ID'] . "\" />";
						echo "<label for='login'>Username:</label>";
						echo "<input required='true' type='input' name='login' value=\"" . $row['Username'] . "\"/>";
						echo "<label for='access'>Access:</label>";
						echo "<select name='access' value='Member'><option value='admin'>Admin</option><option value='member' " . (($row['Level'] === 'member') ? "selected='selected'" : "") . ">Member</option></select>";
						echo "<input type='submit' name='modify' value='Modify'/>";
						echo "</form>";
					}
				}
				else
					echo "<h1>No Users...</h1>";
				mysqli_free_result($db_result);
				mysqli_close($db_conn);
			?>
			</div>
		</li>
	</ul>

	<hr/>
	<h1>Items</h1>

	<ul>
		<li>
			<h3>Add Item:</h3>
			<form method="POST" action="admin.php">
				<label for="item">Item Name:</label>
				<input type="input" name="item" required="true" />
				<label for="img">IMG:</label>
				<input type="input" name="img"/>
				<label for="category">Category:</label>
				<select name="category" required="true">
					<option value="Phone">Phone</option>
					<option value="Accessories">Accessories</option>
					<option value="FastFood">Fast Food</option>
					<option value="Food">Proper Food</option>
					<option value="Misc">Misc.</option>
				</select>
				<label for="price">Price: (R)</label>
				<input type="input" name="price" required="true"/>
				<label for="stock">Stock:</label>
				<input type="input" name="stock" required="true"/>
				<label for="description">Description:</label>
				<input type="input" name="description" size="50"/>
				<input type="submit" name="add" value="ADD"/>
			</form>
		</li>
		<li>
			<h3>Modify Items</h3>
			<table><tr><td width="190px">ITEM NAME</td><td width="130px">PRICE</td><td>STOCK</td></tr></table>
			<div class="userModif">
			<?php
				$db_conn = mysqli_connect($db_server, $db_username, $db_password, $db_name);
				if (!$db_conn)
				{
					echo "Error Connection to database";
					return ;
				}

				$db_query = "SELECT * FROM `items`;";
				$db_result = mysqli_query($db_conn, $db_query);
				if ($db_result)
				{
					while ($row = mysqli_fetch_assoc($db_result))
					{
						echo "<form target='_top' action='admin.php' method='POST' style='margin-bottom:10px;'>";
							echo "<input type='hidden' name='id' value='" . $row['ID'] . "' />";
							echo "<input required='true' size='30' name='ite_name' value='" . $row['Name'] . "' />";
							echo "<input name='ite_price' required='true' value='" . $row['Price'] . "' />";
							echo "<input name='ite_stock' required='true' value='" . $row['Stock'] . "' />";
							echo "<input type='submit' name='modify_item' value='MODIFY'/>";
							echo "<input type='submit' name='remove_item' value='REMOVE'/>";
						echo "</form>";
					}
				}
				else
					echo "<h1>No Users...</h1>";
				mysqli_free_result($db_result);
				mysqli_close($db_conn);
			?>
			</div>
		</li>
	</ul>

	<hr/>
	<h1>Current Orders</h1>
	<ul>
	<?php
		$db_conn = mysqli_connect($db_server, $db_username, $db_password, $db_name);
		if (!$db_conn)
		{
			echo "Error Connection to database";
			return ;
		}

		$db_query = "SELECT * FROM `orders`";
		$db_result = mysqli_query($db_conn, $db_query);
		if ($db_result)
		{
			while ($row = mysqli_fetch_assoc($db_result))
			{
				echo "<li>";
				$db_user_name = mysqli_fetch_assoc(mysqli_query($db_conn, "SELECT Username, Email FROM `users` WHERE ID='" . $row['user_id'] . "';"));
				echo "<h3>USER: " . $db_user_name['Username'] . " (" . $db_user_name['Email'] . ")</h3>";
				$a_file = unserialize($row['user_order']);
				echo "<table><tr><td width='130px'>ITEM</td><td width='40px'>Qty</td><td width='120px'>Price</td><td>TOTAL</td></tr></table>";
				foreach ($a_file as $item)
				{
					echo "<form style='margin-top: 5px;'>";
						echo "<input type='input' readonly='true' value='" . $item['Name'] . "' />";
						echo "<input size='5' type='input' readonly='true' value='" . $item['Qty'] . "' />";
						echo "<input type='input' readonly='true' value='" . $item['Price'] . "' />";
						echo "<input type='input' readonly='true' value='" . $item['Total'] . "' />";
					echo "</form>";
				}
				echo "</li>";
			}
		}
	?>
	</ul>
</body>
</html>