<?php
session_start();
include('config.php');

if (!isset($_SESSION['cart']))
	$_SESSION['cart'] = array();

function	valid_qty($number)
{

	settype($number, "integer");
	if ($number > 0) {
		return (true);
	}
	return(false);
}

$item = $_GET['id'];
$qty = $_GET['quantity'];

if (already_exists($products_file, "id", $item) && valid_qty($qty)) {
	if (count($_SESSION['cart']) !== 0) {
		foreach ($_SESSION['cart'] as $key => $elem) {
			if ($key == $item) {
				$_SESSION['cart'][$key] += $qty;
				redirect('index.php');
				die() ;	
			}
		}
	}
	$_SESSION['cart'][$item] = $qty;
	redirect('index.php');
}
else {
	echo "ERROR\n";
}
?>
