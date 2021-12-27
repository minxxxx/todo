<?php
	session_start();
	if (isset($_GET) && isset($_GET['submit']) && $_GET['submit'] == "OK" && isset($_GET['login']) && isset($_GET['passwd']))
	{
		$_SESSION['login'] = $_GET['login'];
		$_SESSION['passwd'] = $_GET['passwd'];
	}

	if (isset($_SESSION) && isset($_SESSION['login']) && $_SESSION['login'] == NULL)
		$_SESSION['login'] = "";
	if (isset($_SESSION) && isset($_SESSION['passwd']) && $_SESSION['passwd'] == NULL)
		$_SESSION['passwd'] = "";

?>
<html>
	<body>
		<form method="GET" action="index.php">
		Identifiant: <input type="text" name="login" placeholder="login" value="<?=$_SESSION['login']?>"/>
		<br/>
		Mot de passe: <input type="password" name="passwd" placeholder="passwd" value="<?=$_SESSION['passwd']?>"/>
		<input type="submit" name="submit" value="OK"/>
		</form>
	</body>
</html>
