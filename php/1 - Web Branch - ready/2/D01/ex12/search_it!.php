#!/usr/bin/php
<?php
if ($argc <= 2)
	exit();
$to_search = $argv[1];
$in = array_slice($argv, 2);
$final = array();
foreach($in as $elem)
{
	$elem = explode(":", $elem);
	$final[$elem[0]] = $elem[1];
}
if (array_key_exists($to_search, $final))
	echo $final[$to_search];
?>
