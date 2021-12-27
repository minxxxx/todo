#!/usr/bin/php
<?php
if ($argc == 4)
{
	$argv[1] = trim($argv[1]);
	$argv[2] = trim($argv[2]);
	$argv[3] = trim($argv[3]);
	if ($argv[2] == '+')
		$result = $argv[1] + $argv[3];
	else if ($argv[2] == '-')
		$result = $argv[1] - $argv[3];
	else if ($argv[2] == '*')
		$result = $argv[1] * $argv[3];
	else if ($argv[2] == '/')
	{
		if ($argv[3] == '0')
			exit;
		else
			$result = $argv[1] / $argv[3];
	}
	else if ($argv[2] == '%')
	{
		if ($argv[3] == '0')
			exit;
		else
			$result = $argv[1] % $argv[3];
	}
	echo $result."\n";
}
else
	echo "Incorrect Parameters\n";
?>
