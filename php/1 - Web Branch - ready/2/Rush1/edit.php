<?php
include('config.php');

session_start();
$_SESSION['page'] = "edit.php";
if ($_SESSION['whoami'] == "")
	redirect("login.php");
$user = get_user_card($_SESSION['whoami'], $users_file);
if ($_GET['s'] <> "") {
	$err_msg = "\n<font color=\"#ff666\">" . $_GET['s'] . "\n</font><br>";
}
if ($_SESSION['whoami'] != "")
{
	$log =  "<a href=\"logout.php\" title=\"D&eacute;connexion\">Logout</a>";
	$account =  "<a href=\"edit.php\" title=\"Mon compte\">My account</a>";
}
else
{
	$log =  "<a href=\"login.php\" title=\"Connexion\">Log in</a>";
	$account = "";
}
?>
<!DOCTYPE html>
<html>
	<head>
		<title>42riders: Modify profile</title>
		<link href="css/main.css" rel="stylesheet" type="text/css" media="all">
	</head>
<div id="header">
<h1>42riders</h1>
</div>
<div id="nav">
	<?php if (get_user_type($_SESSION['whoami'], $users_file) == 'admin') { echo "<b><a href='admin.php'>Admin</a></b>"; } ?>
	<?php if ($account) { echo $account; } ?>
	<a href="index.php?page=products">Products</a>
	<a href="index.php?page=checkout">Checkout</a>
	<?php echo $log; ?>
</div>
<div id="section">
<h2>Edit profile:</h2>
			<form action="modif.php" method="POST">
				<?php echo $err_msg; ?>
Your username: <input type="text" name="login" value="<?php echo $_SESSION['whoami'] ?>" readonly/>
				<br />
				First name: <input type="text" name="fn" value="<?php echo $user['first']; ?>" /> Last name: <input type="text" name="ln" value="<?php echo $user['last']; ?>"/>
				<br />
				Modify your password (eventually): <input type="password" name="newpw" />
				<br />
				Enter your email address: <input type="text" name="email" value="<?php echo $user['email'] ?>"/>
				<br />
				Enter your physical address: <input type="text" name="address" value="<? echo $user['address']; ?>"/>
				<br />
<?php if ($_SESSION['whoami'] != 'admin') { ?>
Delete your account: <b>this action is irreversible</b> <input type="checkbox" name="del" value="yes"><br />
<?php } ?>
				Confirm your (current) password: <input type="password" name="passwd" />
				<br />
				<input type="submit" name="submit" value="OK" />
			</form>
</div>
<div id="footer">
Copyright 2016 © dtedgui, rliou-ke
</div>

</body>
</html>
