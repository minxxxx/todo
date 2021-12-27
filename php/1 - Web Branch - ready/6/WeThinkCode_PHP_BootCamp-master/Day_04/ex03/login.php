<?PHP
	session_start();
	include("auth.php");

	if ($_GET["login"] && $_GET["passwd"] && auth($_GET["login"], $_GET["passwd"]))
	{
		$_SESSION['user_session'] = $_GET["login"];
		echo "OK\n";
	}
	else
	{
		$_SESSION['user_session'] = "";
		echo "ERROR\n";
	}
?>
