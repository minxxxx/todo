<?php
	session_start();
	if ($_SESSION['logged_on'] != null || $_SESSION['logged_on'] !== "")
	{
		$_SESSION['access_level'] = -1;
		$_SESSION['logged_on'] = null;
	}
	header("Location: index.php");
?>