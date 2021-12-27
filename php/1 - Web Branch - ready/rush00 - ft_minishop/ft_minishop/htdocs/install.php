<?php
if (!($mysqli = mysqli_connect("localhost:3306", "root", "qwerty")))
	exit("Could not connect: ".mysqli_connect_error().PHP_EOL);
if (!($queries = file_get_contents("rush00.sql")))
	exit("Could not import database.".PHP_EOL);
$queries = str_replace("\n", "", $queries);
if (!(mysqli_multi_query($mysqli, $queries)))
	echo "Could not create database.".PHP_EOL;
else
	echo "Database imported successfully".PHP_EOL;
if (!(mysqli_close($mysqli)))
	echo "Could not close connection.".PHP_EOL;
?>
