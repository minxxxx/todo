#!/usr/bin/php
<?PHP
if ($argc > 1)
	echo preg_replace("/[\ \t]+/", " ", trim($argv[1], " \t")).PHP_EOL;
?>
