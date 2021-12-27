<?php
function newusr_check_input($sql_ptr)
{
	if (!preg_match("/^([0-9A-Za-z]*)$/", $_POST['login']))
		return 'Login';
	if (!preg_match("/^([0-9A-Za-z]*)$/", $_POST['password']))
		return 'Password';
	if (!preg_match("/^([A-Za-z]*)$/", $_POST['lastname']))
		return 'Lastname';
	if (!preg_match("/^([A-Za-z]*)$/", $_POST['firstname']))
		return 'Firstname';
	if (!preg_match("/^([0-9A-Za-z ]*)$/", $_POST['address']))
		return 'Address';
	if (!preg_match("/^([0-9]{5})$/", $_POST['zipcode']))
		return 'Zipcode';
	if (!preg_match("/^([A-Za-z]*)$/", $_POST['city']))
		return 'City';
	$_POST['login'] = mysqli_real_escape_string($sql_ptr, $_POST['login']);
	$_POST['password'] = mysqli_real_escape_string($sql_ptr, $_POST['password']);
	$_POST['lastname'] = mysqli_real_escape_string($sql_ptr, $_POST['lastname']);
	$_POST['firstname'] = mysqli_real_escape_string($sql_ptr, $_POST['firstname']);
	$_POST['address'] = mysqli_real_escape_string($sql_ptr, $_POST['address']);
	$_POST['zipcode'] = mysqli_real_escape_string($sql_ptr, $_POST['zipcode']);
	$_POST['city'] = mysqli_real_escape_string($sql_ptr, $_POST['city']);
	return NULL;
}
function newusr_create_user($sql_ptr)
{
	$ret = mysqli_query($sql_ptr, 'SELECT login FROM users WHERE login="'.
		mysqli_real_escape_string($sql_ptr, $_POST["login"]).'";');
	if (mysqli_num_rows($ret) == 0)
	{
		$ret = mysqli_query($sql_ptr, "INSERT INTO `users` (id, login, password, lastname, firstname, address, zipcode, city, admin) VALUES (NULL, '".
			mysqli_real_escape_string($sql_ptr, $_POST["login"])."', '".hash("Whirlpool", $_POST["password"])."', '".
			mysqli_real_escape_string($sql_ptr, $_POST["lastname"])."', '".
			mysqli_real_escape_string($sql_ptr, $_POST["firstname"])."', '".
			mysqli_real_escape_string($sql_ptr, $_POST["address"])."', '".
			mysqli_real_escape_string($sql_ptr, $_POST["zipcode"])."', '".
			mysqli_real_escape_string($sql_ptr, $_POST["city"])."', 0);");
		save_action_and_reload("User created, you can now connect yourself");
	}
	else
		save_action_and_reload("This login already exist");
}
function newusr($sql_ptr)
{
	if (empty($_POST['login']) || empty($_POST['password']) 
		|| empty($_POST['lastname']) || empty($_POST['firstname'])
			|| empty($_POST['address'])|| empty($_POST['zipcode'])
				|| empty($_POST['city']))
					save_action_and_reload("Please fill all the fields");
	else if (($err = newusr_check_input($sql_ptr)) === NULL)
		newusr_create_user($sql_ptr);
	else
		save_action_and_reload($err." is invalid !");
}
function connectusr_sqlcomp($sql_ptr)
{
	$ret = mysqli_query($sql_ptr, 'SELECT * FROM users WHERE login="'.
		mysqli_real_escape_string($sql_ptr, $_POST["login"]).'" AND password="'.hash("Whirlpool", $_POST["password"]).'";');
	if (mysqli_num_rows($ret) == 0)
		return false;
	return true;
}
function connectusr_check_input($sql_ptr)
{
	$_POST['login'] = mysqli_real_escape_string($sql_ptr, $_POST['login']);
	$_POST['password'] = mysqli_real_escape_string($sql_ptr, $_POST['password']);
	if (!preg_match("/^([0-9A-Za-z]*)$/", $_POST['login']) || !preg_match("/^([0-9A-Za-z]*)$/", $_POST['password']))
		return false;
	return true;
}
function connectusr($sql_ptr)
{
	if (empty($_POST['login']) || empty($_POST['password']))
		save_action_and_reload("Please fill all the fields");
	else if (!($err = connectusr_check_input($sql_ptr)) || !connectusr_sqlcomp($sql_ptr))
		save_action_and_reload("Wrong combinaison login/password");
	else
	{
		$_SESSION['login'] = $_POST['login'];
		save_action_and_reload("You are now logged in as ".$_POST['login']);
	}	
}
function logoutusr()
{
	$_SESSION['login'] = '';
	save_action_and_reload("Logged out");
}
?>

<!doctype html>
<html><head>
	<title>ft_minishop</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="/ft_minishop.css">
	<link rel="stylesheet" type="text/css" href="/previews_css.css">
</head><body>
	<div class="main-box">
		<?php require($_SERVER['DOCUMENT_ROOT']."/header.php");?>
		<div class="content-box">
			<?php
			require($_SERVER['DOCUMENT_ROOT']."/cart.php");
			if (isset($_POST['submit_type']))
			{
				if ($_POST['submit_type'] === 'newusr')
					newusr($sql_ptr);
				else if ($_POST['submit_type'] === 'connect')
					connectusr($sql_ptr);
				else if ($_POST['submit_type'] === 'clrcart')
					clear_cart();
				else if ($_POST['submit_type'] === 'logout')
					logoutusr();
				else if ($_POST['submit_type'] === 'checkout')
					checkout_cart($sql_ptr);
			}
			echo '<div class="half_pane">';
			require($_SERVER['DOCUMENT_ROOT']."/item_preview.php");			
			echo '<br />';
			echo '<br />';
			if ($_SESSION['login'] === 'root')
				require($_SERVER['DOCUMENT_ROOT']."/admin_box.php");
			if (!empty($_SESSION['login']))
				require($_SERVER['DOCUMENT_ROOT']."/user_box.php");
			if (!empty($_SESSION['login']))
				require($_SERVER['DOCUMENT_ROOT']."/commands_box.php");
			if (empty($_SESSION['login']))
				require($_SERVER['DOCUMENT_ROOT']."/newuser_box.php");
			echo '</div>';
			echo '<div class="half_pane">';
			require($_SERVER['DOCUMENT_ROOT']."/item_preview.php");			
			require($_SERVER['DOCUMENT_ROOT']."/cart_box.php");
			echo '</div>';
			?>
		</div>
		<?php require($_SERVER['DOCUMENT_ROOT']."/footer.html"); ?>
	</div>
</body></html>
