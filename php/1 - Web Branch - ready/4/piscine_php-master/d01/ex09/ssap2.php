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
	$array_alpha = array();
	$array_numeric = array();
	$array_else = array();
	$ia = 0;
	$in = 0;
	$ie = 0;
	foreach ($array as $elem)
	{
		if (ctype_alpha($elem))
		{
			$array_alpha[$ia] = $elem;
			$ia++;
		}
		else if (is_numeric($elem))
		{
			$array_numeric[$in] = $elem;
			$in++;
		}
		else
		{
			$array_else[$ie] = $elem;
			$ie++;
		}
	}
	sort($array_alpha, SORT_STRING | SORT_FLAG_CASE);
	sort($array_numeric, SORT_STRING);
	sort($array_else, SORT_STRING | SORT_FLAG_CASE);
	foreach ($array_alpha as $elem)
		echo $elem."\n";
	foreach ($array_numeric as $elem)
		echo $elem."\n";
	foreach ($array_else as $elem)
		echo $elem."\n";
}
?>
