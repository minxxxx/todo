<?PHP
	session_start();
	if ($_SESSION['user_session'] !== NULL && $_SESSION['user_session'] !== "")
	{
		echo $_SESSION['user_session'] . "\n";
	}
	else
	{
		$_SESSION['user_session'] = "";
		echo "ERROR\n";
	}
?>
