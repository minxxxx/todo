#!/usr/bin/php
<?php
	$arr = array();

	for ($i = 1; $i < count($argv); $i++)
	{
		$replace = eregi_replace("[ ]+", " ", $argv[$i]);
		$split = explode(" ", $replace);
		if (count($split) > 1)
			foreach ($split as $str)
				array_push($arr, $str);
		else
			array_push($arr, $argv[$i]);
	}

	$alpha = array();
	$num = array();
	$special = array();
	for ($i = 0; $i < count($arr); $i++)
	{
		if (ctype_alpha($arr[$i]))
			array_push($alpha, $arr[$i]);
		else if (ctype_digit($arr[$i]))
			array_push($num, $arr[$i]);
		else
			array_push($special, $arr[$i]);
	}
	usort($alpha, "strnatcasecmp");
	rsort($num);
	sort($special);
	foreach ($alpha as $str)
		echo $str . "\n";
	foreach ($num as $d)
		echo $d . "\n";
	foreach($special as $spe)
		echo $spe . "\n";
?>
