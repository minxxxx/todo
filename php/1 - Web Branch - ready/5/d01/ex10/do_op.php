#!/usr/bin/php
<?PHP
if ($argc != 4)
{
	echo "Incorrect Parameters".PHP_EOL;
	return ;
}
$nb1 = trim($argv[1], " \t");
$nb2 = trim($argv[3], " \t");
$sign = trim($argv[2], " \t");
if ($sign == "+")
	echo ($nb1 + $nb2).PHP_EOL;
else if ($sign == "-")
	echo ($nb1 - $nb2).PHP_EOL;
else if ($sign == "*")
	echo ($nb1 * $nb2).PHP_EOL;
else if ($sign == "/")
	echo ($nb1 / $nb2).PHP_EOL;
else if ($sign == "%")
	echo ($nb1 % $nb2).PHP_EOL;
?>
