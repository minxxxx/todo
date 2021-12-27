#!/usr/bin/php
<?php
if ($argc != 4)
{
	echo "Incorrect Parameters\n";
	exit();
}
function calculate($nb1, $nb2, $op)
{
	if (!is_numeric($nb1) || !is_numeric($nb2))
		return "Syntax Error";
	if ($op == "+")
		return $nb1 + $nb2;
	else if ($op == "-")
		return $nb1 - $nb2;
	else if ($op == "*")
		return $nb1 * $nb2;
	else if ($op == "/")
		return $nb1 / $nb2;
	else if ($op == "%")
		return $nb1 % $nb2;

}

$tab = array();
foreach($argv as $i => $el)
{
	if ($i == 0)
		continue;
	array_push($tab, trim($el));
}
echo calculate($tab[0], $tab[2], $tab[1]);
?>
