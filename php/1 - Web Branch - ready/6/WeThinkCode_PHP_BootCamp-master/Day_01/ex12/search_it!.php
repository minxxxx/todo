#!/usr/bin/php
<?php
if ($argv[2])
{
	$temp = $argv;
	foreach ($temp as $str)
	{
		if ($str == $temp[0] || $str == $temp[1])
			continue ;
		$elem = explode(":", $str);
		if (count($elem) > 2)
			$key[$elem[0]] = substr($str, strlen($elem[0]) + 1);
		else
			$key[$elem[0]] = $elem[1];
	}
	if ($key[$argv[1]])
		echo $key[$argv[1]]."\n";
}
?>
