#!/usr/bin/php
<?PHP

if ($argc != 2)
{
	echo "Incorrect Parameters".PHP_EOL;
	return ;
}

$str = trim($argv[1], " \t");
if (preg_match("/^[\ \t]*([+-]?[0-9]*)[\ \t]*([\+\-\*\/\%])[\ \t]*([+-]?[0-9]*)[\ \t]*$/", $str, $array))
{
	if ($array[2] == "+")
		echo ($array[1] + $array[3]).PHP_EOL;
	else if ($array[2] == "-")
		echo ($array[1] - $array[3]).PHP_EOL;
	else if ($array[2] == "*")
		echo ($array[1] * $array[3]).PHP_EOL;
	else if ($array[2] == "/")
		echo ($array[1] / $array[3]).PHP_EOL;
	else if ($array[2] == "%")
		echo ($array[1] % $array[3]).PHP_EOL;
}
else
	echo "Syntax Error".PHP_EOL;
?>
