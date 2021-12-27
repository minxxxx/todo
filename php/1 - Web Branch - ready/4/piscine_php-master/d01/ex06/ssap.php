#!/usr/bin/php
<?php
if ($argc > 1)
{
	$array[] = "";
	foreach ($argv as $elem)
	{
		$split = array_filter(explode(" ", $elem), 'strlen');
		$array = array_merge($array, $split);
	}
	$array = array_filter($array, 'strlen');
	array_shift($array);
	sort($array);
	foreach($array as $elem)
		echo "$elem\n";
}
?>
