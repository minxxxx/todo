#!/usr/bin/php
<?php
function ft_split($string)
{
	$result = array();
	$exploded = explode(" ", $string);
	foreach($exploded as $elem)
	{
		if ($elem)
			array_push($result, $elem);
	}
	return $result;
}

if ($argv[1])
{
	$result = ft_split($argv[1]);
	if (count($result) == 1)
		echo "$argv[1]\n";
	else
	{
		$first = array_shift($result);
		array_push($result, $first);
		echo implode(" ", $result);
	}
}
?>
