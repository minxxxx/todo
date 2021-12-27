#!/usr/bin/php
<?PHP
if ($argc == 2)
{
	$str = trim($argv[1], " ");
	if (strlen($str) != 0)
		echo preg_replace('/\ \ +/', ' ', trim($argv[1], " ")).PHP_EOL;
}
?>
