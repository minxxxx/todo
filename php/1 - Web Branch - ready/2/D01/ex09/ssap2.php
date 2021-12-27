#!/usr/bin/php
<?php
function ssap_sort($tab)
{
	$number = array();
	$letter = array();
	$other = array();
	foreach($tab as $elem)
	{
		$first = ord($elem[0]);
		if (($first >= 65 && $first <= 90) || ($first >= 97 && $first <= 122))
			array_push($letter, $elem);
		else if ($first >= 48 && $first <= 57)
			array_push($number, $elem);
		else
			array_push($other, $elem);
	}
	sort($letter, SORT_FLAG_CASE | SORT_NATURAL);
	sort($number, SORT_STRING);
	sort($other);
	$tab = array_merge($letter, $number, $other);
	return $tab;
}

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
$result = ssap_sort($result);
foreach($result as $elem)
{
	echo "$elem\n";
}
?>
