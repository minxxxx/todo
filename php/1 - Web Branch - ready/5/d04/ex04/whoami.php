<?php
	session_start();
	if (!isset($_SESSION["loggued_on_user"]) || $_SESSION["loggued_on_user"] === NULL || $_SESSION["loggued_on_user"] === "")
		echo "ERROR".PHP_EOL;
	else
		echo $_SESSION['loggued_on_user'].PHP_EOL;
?>
