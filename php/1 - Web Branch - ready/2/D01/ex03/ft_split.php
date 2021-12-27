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
	sort($result);
	return $result;
}
print_r(ft_split("Hello    world AAA"));
?>
