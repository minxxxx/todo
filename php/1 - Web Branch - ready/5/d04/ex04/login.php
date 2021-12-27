<?php
	session_start();
	include("auth.php");

	function put_it($login, $msg)
	{
		$_SESSION["loggued_on_user"] = $login;
		echo $msg;
	}

	if (!isset($_GET["login"]) || !isset($_GET["passwd"]) || !$_GET["login"] || !$_GET["passwd"])
		put_it("", "ERROR\n");
	else if (!auth($_GET["login"], $_GET["passwd"]))
		put_it("", "ERROR\n");
	else
		put_it($_GET["login"], "OK\n");
?>
