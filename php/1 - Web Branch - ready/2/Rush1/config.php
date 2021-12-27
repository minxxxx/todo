<?php

$users_file = './private/passwd';
$products_file = './private/products';
$upload_dir = "./img/";

function get_content($file, $strict) // if $strict is set to TRUE then if file $does not exists the function will return (false)
{									// else it will create a new array
	$path = reverse_strrchr($file, "/");
	if (!file_exists($path))
		mkdir($path);
	if (file_exists($file))
		$file = unserialize(file_get_contents($file));
	else if ($strict == TRUE)
		return (false);
	else
		$file = array();
	return ($file);
}

function redirect($filename)
{
	if (!headers_sent())
		@header('Location: '.$filename);
	else {
		echo '<script type="text/javascript">';
		echo 'window.location.href="'.$filename.'";';
		echo '</script>';
		echo '<noscript>';
		echo '<meta http-equiv="refresh" content="0;url='.$filename.'" />';
		echo '</noscript>';
	}
}

function auth($login, $passwd, $path)
{
	if (file_exists($path)) {
		if (!($table = unserialize(file_get_contents($path))))
			return (false);
	} else {
		return (false);
	}
	$pw = hash('sha256', $passwd);
	foreach($table as $account) {
		if ($login == $account['login'] && $pw == $account['passwd']) {
			return (true);
		}
	}
	return (false);
}

function reverse_strrchr($haystack, $needle)
{
	$pos = strrpos($haystack, $needle);
	if($pos === FALSE)
		return $haystack;
	return substr($haystack, 0, $pos + 1);
}

function get_user_type($login, $file)
{
	if ($login != "") {
		if ($users = get_content($file, TRUE)) {
			foreach ($users as $user) {
				if ($user['login'] == $login)
					return $user['type'];
			}
		}
	}
	return FALSE;
}

function get_user_card($login, $users_file)
{
	if (!file_exists($users_file)) {
		return FALSE;
	}
	$users = unserialize(file_get_contents($users_file));
	foreach ($users as $i => $user)
	{
		if ($user['login'] == $login)
			return ($users[$i]);
	}
	return FALSE;
}

function get_product_card($key, $value, $products_file)
{
	if (!($products = get_content($products_file, TRUE))) {
		return FALSE;
	}
	foreach ($products as $i => $product) {
		if ($product[$key] == $value)
			return ($products[$i]);
	}
	return FALSE;
}

function modify_user($login, $field, $new_value, $file)
{
	if ($users = get_content($file, TRUE)) {
		foreach ($users as $i => $user) {
			if ($user['login'] == $login) {
				$users[$i][$field] = $new_value;
				break;
			}
		}
		file_put_contents($file, serialize($users));
	}
}

function user_exists($login, $file)
{
	if (!file_exists($file))
		return FALSE;
	$users = unserialize(file_get_contents($file));
	foreach ($users as $user)
	{
		if ($user['login'] == $login)
			return TRUE;
	}
	return FALSE;
}

function already_exists($file, $key, $value)
{
	if (!($data = get_content($file, TRUE)))
		return (false);
	foreach ($data as $elem) {
		if ($elem[$key] == $value)
			return (true);
	}
	return (false);
}
?>
