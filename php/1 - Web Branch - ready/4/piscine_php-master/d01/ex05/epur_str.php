#!/usr/bin/php
<?php
if ($argc == 2)
{
	$array = array_filter(explode(" ", $argv[1]), 'strlen');
	$i = 1;
	$nb_elem = count($array);
	foreach ($array as $elem)
	{
		if ($i <= $nb_elem - 1)
			echo "$elem ";
		else
			echo "$elem";
		$i++;
	}
	echo "\n";
}
?>
