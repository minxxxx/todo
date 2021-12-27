<?php
include('config.php');
session_start();

if (!$_POST)
	redirect('index.php');

function update_card($file, $key_id, $qty)
{
	$item = get_product_card("id", $key_id, $file);

	if (!$item) {
		exit("get_user_card failed");
	}
	$item['quantity'] = $item['quantity'] - $qty;
	return ($item);
}
if ($_SESSION['whoami'] == "") {
	redirect("login.php");
} else {
	if ($_POST['validate'] == "Complete Order") {
		foreach ($_SESSION['cart'] as $id => $qty) {
			$data = get_content($products_file, TRUE);
			foreach ($data as $i => $elem) {
				if ($elem['id'] == $id) {
					if ((intval($elem['quantity']) - $qty) < 0) {
						$_SESSION['ordercomplete'] = "no";
						redirect('index.php?page=orders');
						exit ;
					}
					$data[$i] = update_card($products_file, $id, $qty);
					break ;
				}
			}
			file_put_contents($products_file, serialize($data));
		}
		$_SESSION['cart'] = "";
		unset($_SESSION['cart']);
		$_SESSION['ordercomplete'] = "yes";
		redirect('index.php?page=orders');
	} else {
		if ($_POST['empty'] == "Empty cart") {
			$_SESSION['cart'] = "";
			unset($_SESSION['cart']);
			redirect('index.php?page=orders');
		}
	}
}
?>
