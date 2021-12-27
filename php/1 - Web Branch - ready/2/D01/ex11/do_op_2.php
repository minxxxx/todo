#!/usr/bin/php
<?php

if ($argc != 2)
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

function find_operator($tab)
{
	if (in_array('-', $tab))
		return array_search('-', $tab);
	else if (in_array('*', $tab))
		return array_search('*', $tab);
	else if (in_array('/', $tab))
		return array_search('/', $tab);
	else if (in_array('+', $tab))
		return array_search('+', $tab);
	else if (in_array('%', $tab))
		return array_search('%', $tab);
}

function split_and_trim($string)
{
	$splitted = str_split($string);
	$result = array();
	foreach($splitted as $elem)
	{
		$elem = trim($elem);
		if ($elem)
			array_push($result, $elem);
	}
	return ($result);
}

$tab = split_and_trim($argv[1]);
$operator = find_operator($tab);
$op1 = implode(array_slice($tab, 0, $operator));
$op2 = implode(array_slice($tab, $operator + 1));
echo calculate($op1, $op2, $tab[$operator]);

?>
