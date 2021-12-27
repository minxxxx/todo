#!/usr/bin/php
<?php
$data = file_get_contents($argv[1]);

if (!$data)
	exit();

$lines = explode("\n", $data);
$count = count($lines) - 1;

$keys = explode(";", $lines[0]);
$arr = [];

if (!array_search($argv[2], $keys))
	exit();

for ($i=1; $i < $count; $i++)
{
	$line = explode(";", $lines[$i]);
	array_push($arr, $line);
}

foreach ($arr as $key => $value)
{
	$key_arg = $value[array_search($argv[2], $keys)];
	foreach ($keys as $key2 => $key_value)
	{
		${$key_value}[$key_arg] = $value[$key2];
	}
}

while ("LEGEND")
{
	echo "Entrez votre commande: ";
	$fp = fopen('php://stdin', 'r');
    if (!($line = fgets($fp)))
    {
    	echo "\n";
    	exit();
    }
    eval($line);
}
?>
