<?php
$cart;
function load_cart(&$cart, $sql_ptr)
{
	if (empty($_SESSION['cart']))
		$_SESSION['cart'] = NULL;
	$cart = explode(";", $_SESSION['cart']);
}
function print_cart($sql_ptr)
{
	if (empty($_SESSION['cart']))
	{
		echo "Cart is empty...";
		return ;
	}
	foreach (array_count_values(explode(";", $_SESSION['cart'])) as $k => $v)
	{
		if (($ret = mysqli_query($sql_ptr, 'SELECT name, price FROM items WHERE id="'.
			mysqli_real_escape_string($sql_ptr, $k).'";')) === false)
			save_action_and_reload("Cannot print the cart (mySQL error)");
		$ret = mysqli_fetch_assoc($ret);
		if (!empty($ret['name']) && !empty($ret['price']))
		{
			$str = "";
			if ($ret['price'] < 1000.)
				$str .= "&nbsp;";
			$str .= money_format('%!10.2n &euro;', (float)$ret['price'] / 100.).
				"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;".$ret['name']." x".$v."<br/>";
			echo $str;
		}
	}
	$total = 0;
	foreach (explode(";", $_SESSION['cart']) as $k)
	{
		if (($ret = mysqli_query($sql_ptr, 'SELECT price FROM items WHERE id="'.
			mysqli_real_escape_string($sql_ptr, $k) .'";')) === false)
			save_action_and_reload("Cannot print the cart (mySQL error)");
		$ret = mysqli_fetch_assoc($ret);
		if (!empty($ret['price']))
			$total += $ret['price']/100;
	}
	echo "<h4>TOTAL : &nbsp;".$total."&euro;</h4>";
}
function add_to_cart(&$cart)
{
	$cart[] = $_GET['id'];
	$_SESSION['cart'] = implode(";", $cart);
	save_action_and_reload("Added to cart");
}
function clear_cart()
{
	$_SESSION['cart'] = NULL;
	save_action_and_reload("The cart has been cleared");
}
function checkout_cart($sql_ptr)
{
	if (empty($_SESSION['cart']))
		save_action_and_reload("Nothing to checkout");
	if (empty($_SESSION['login']))
		save_action_and_reload("You must be connected to checkout");
	if (($cmd_usr_id = mysqli_query($sql_ptr, 'SELECT id FROM users WHERE login="'.
		mysqli_real_escape_string($sql_ptr, $_SESSION['login']).'";')) === false)
		save_action_and_reload("Cannot checkout (mySQL error)");
	$cmd_usr_id = mysqli_fetch_assoc($cmd_usr_id);
	$cmd_total = 0;
	$unserlz_cart = explode(";", $_SESSION['cart']);
	foreach ($unserlz_cart as $k)
	{
		if (($ret = mysqli_query($sql_ptr, 'SELECT price FROM items WHERE id="'.
			mysqli_real_escape_string($sql_ptr, $k).'";')) === false)
			save_action_and_reload("Cannot checkout (mySQL error)");
		$ret = mysqli_fetch_assoc($ret);
		if (!empty($ret['price']))
			$cmd_total += $ret['price'];
	}
	$request = 'INSERT INTO commands (`id`, `user_id`, `items`, `amount`, `date`) VALUES (NULL, '.
		mysqli_real_escape_string($sql_ptr, $cmd_usr_id['id']).', "'.
		mysqli_real_escape_string($sql_ptr, $_SESSION['cart']).'", '.
		mysqli_real_escape_string($sql_ptr, $cmd_total).', NOW());';
	if (($ret = mysqli_query($sql_ptr, $request)) === false)
		save_action_and_reload("Cannot checkout (mySQL error)");
	$_SESSION['cart'] = NULL;
	save_action_and_reload("Order confirmed");
}
load_cart($cart, $sql_ptr);
?>
