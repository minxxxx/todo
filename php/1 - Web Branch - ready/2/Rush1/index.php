<?php
session_start();
include('config.php');

if ($_SESSION['whoami'] != "")
{
	$log =  "<a href=\"logout.php\" title=\"D&eacute;connexion\">Logout</a>";
	$account =  "<a href=\"edit.php\" title=\"Mon compte\">My account</a>";
}
else
{
	$log =  "<a href=\"login.php\" title=\"Connexion\">Login</a>";
	$account = "";
}
$_SESSION['page'] = "index.php";
?>
<!DOCTYPE html>
<html>
	<head>
		<title>42riders: Welcome aboard the ride</title>
		<link href="css/main.css" rel="stylesheet" type="text/css" media="all">
	</head>
<body>

<div id="header">
<h1>42riders</h1>
</div>

<div id="nav">
	<?php if (get_user_type($_SESSION['whoami'], $users_file) == 'admin') { echo "<b><a href='admin.php'>Admin</a></b>"; } ?>
	<?php if ($account) { echo $account; } ?>
	<a href="index.php?page=products">Products</a>
	<a href="index.php?page=checkout">Checkout</a>
	<?php echo $log; ?>
	<?php if ($_SESSION['whoami'] == "" || empty($_SESSION['whoami'])) { echo "<a href=\"register.php\">Sign up</a>"; } ?>
</div>

<div id="section">
<?php
if ($_GET['page'] == 'products')
{
?>
<table>
	<thead>
		<th>Product</th>
		<th>Photo</th>
		<th>Description</th>
		<th>Price</th>
		<th>Add to cart</th>
	</thead>
	<tbody>
		<?php
			if ($all_products = get_content($products_file, TRUE)) {
				foreach($all_products as $product) {
					echo "<tr>\n";
					echo "<td>". $product['name'] ."</td>\n";
					echo "<td><a href='". $product['photo'] ."'><img src='". $product['photo'] ."' /></a></td>\n";
					echo "<td class='prod_desc'>". $product['description'] ."</td>\n";
					echo "<td>". $product['price'] ." $</td>\n";
					echo "<td><form method='get' action='./add_to_cart.php'>";
					echo "<input type='hidden' name='id' value='{$product['id']}'>";
					if ($product['quantity'] == 0)
						echo "Out of stock";
					else
					{
						echo "<select name='quantity'>";
						$i = 1;
						while ($i <= $product['quantity']) {
							echo "<option value='{$i}'>{$i}</option>";
							$i++;
						}
						echo "<input type='submit' value='OK' />";
					}
					echo "</form></td>";
					echo "</tr>\n";
				}
			}
		?>
	</tbody>
</table>
<?php
}
else if ($_GET['page'] == 'checkout')
	include('checkout.php');
else if ($_GET['page'] == 'orders') {
	if ($_SESSION['ordercomplete'] == "no") {
		echo "<h2>I'm afraid that we are out of stock!</h2>";
		$_SESSION['ordercomplete'] == "";
		unset($_SESSION['ordercomplete']);
	}
	else if ($_SESSION['ordercomplete'] == "yes") {
		echo "<h2>Your order has been sent!</h2>";
		$_SESSION['ordercomplete'] == "";
		unset($_SESSION['ordercomplete']);
	} else {
		redirect("index.php?page=products");
	}
}
else
	redirect("index.php?page=products");
?>
</div>
<div id="footer">
Copyright 2016 © dtedgui, rliou-ke
</div>

</body>
</html>
