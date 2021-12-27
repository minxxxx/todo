#!/usr/bin/php
<?PHP

function ft_split($s)
{
	$s = trim($s, " ");
	$s = preg_replace('/\ \ +/', ' ', $s);
	if (strlen($s) == 0)
		return (array());
	return explode(" ", $s);
}

if ($argc > 1)
{
	$array = ft_split($argv[1]);
	array_push($array, array_shift($array));
	foreach($array as $k => $v)
		echo $v." ";
	echo PHP_EOL;
}
?>
