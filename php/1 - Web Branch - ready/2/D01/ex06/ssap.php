#!/usr/bin/php
<?php
$result = array();
foreach($argv as $i => $elem)
{
	if ($i == 0)
		continue;
	$words = explode(" ", $elem);
	if (count($words) == 1)
		array_push($result, $elem);
	else
	{
		foreach($words as $el)
		{
			if ($el)
				array_push($result, $el);
		}
	}
}
sort($result);
print_r($result);
?>
