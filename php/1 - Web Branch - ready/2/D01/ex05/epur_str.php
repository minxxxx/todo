#!/usr/bin/pho
<?php
$result = array();
$tab = explode(" ", $argv[1]);
foreach($tab as $elem)
{
	if ($elem)
		array_push($result, $elem);
}
$count = count($result);
foreach($result as $i => $elem)
{
	echo $elem;
	if ($i != $count - 1)
		echo " ";
}
?>
