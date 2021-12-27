<?php
if (!isset($_SESSION['cart']) || $_SESSION['cart'] == "" || count($_SESSION['cart']) === 0) {
	echo "<h1>Shopping cart is empty!</h1>";
}
else {
	echo "<h2>{$_GET['s']}</h2>";
	$total = 0;
	echo "<form action=\"orders.php\" method=\"POST\">";
	echo "<table>";
	echo "<tr>";
	echo "<td>Product</td>";
	echo "<td>Image</td>";
	echo "<td>Description</td>";
	echo "<td>Price</td>";
	echo "<td>Quantity</td>";
	echo "</tr>";
	foreach ($_SESSION['cart'] as $key => $value) 
	{	
		settype($product['price'], "integer");
		$product = get_product_card("id", $key, $products_file);
		$total += $value * $product['price'];
		echo "<tr>";
		echo "<td>{$product['name']}</td>";
		echo "<td><img src=\"{$product['photo']}\" alt=\"photo\"></td>";
		echo "<td>{$product['description']}</td>";
		echo "<td>$ {$product['price']}</td>";
		echo "<td>{$value}</td>";
		echo "</tr>";
	}

	echo "<tr>";
	echo "<td colspan=3>TOTAL</td>";
	echo "<td>$ {$total}</td>";
	echo "</tr>";
	echo "</table>";
	$_SESSION['order'] = $product;
	echo "<br /><input type=\"submit\" name=\"validate\" value=\"Complete Order\" /><br />";
	echo "<br /><input type=\"submit\" name=\"empty\" value=\"Empty cart\" /><br />";
	echo "</form>";
	
}
?>
