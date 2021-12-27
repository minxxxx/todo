#!/usr/bin/php
<?php
if ($argc > 1)
{
	$array = array_filter(explode(" ", $argv[1]), 'strlen');
	$elem0 = array_shift($array);
	foreach ($array as $elem)
		echo $elem." ";
	echo $elem0."\n";
}
?>
