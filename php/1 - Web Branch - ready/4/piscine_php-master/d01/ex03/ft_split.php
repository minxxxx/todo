<?php

function ft_split($string)
{
	$array = array_filter(explode(" ", $string), 'strlen');
	sort($array);
	return ($array);
}
?>
