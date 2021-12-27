#!/usr/bin/php
<?php
if ($argc <= 1)
	exit();
$str = trim($argv[1]);
echo preg_replace("/\s+/", " ", $str);
?>
