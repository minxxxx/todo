#!/usr/bin/php
<?PHP

function ft_split($s)
{
	$s = trim($s, " ");
	$s = preg_replace('/\ \ +/', ' ', $s);
	return explode(" ", $s);
}

$tab = array();
foreach($argv as $k => $v)
	if ($k > 0)
		$tab = array_merge($tab, ft_split($v));
sort($tab);
foreach($tab as $k => $v)
	if ($v != "")
		echo $v.PHP_EOL;
?>
