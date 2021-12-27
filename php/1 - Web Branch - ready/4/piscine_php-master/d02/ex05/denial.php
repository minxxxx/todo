#!/usr/bin/php
<?php
if ($argc == 3)
{
	if (!file_exists($argv[1]))
		exit;
	if (substr($argv[1], -4) != ".csv")
		exit;
	if ($argv[2] != "nom" && $argv[2] != "prenom" && $argv[2] != "mail" && $argv[2] != "IP" && $argv[2] != "pseudo")
		exit;
	if (($file = fopen($argv[1], 'r')) == false)
		exit;
	if ($argv[2] == "nom")
		$i = 0;
	else if ($argv[2] == "prenom")
		$i = 1;
	else if ($argv[2] == "mail")
		$i = 2;
	else if ($argv[2] == "IP")
		$i = 3;
	else if ($argv[2] == "pseudo")
		$i = 4;
	while ($fields = fgetcsv($file, 0, ";"))
	{
		$nom[$fields[$i]] = $fields[0];
		$prenom[$fields[$i]] = $fields[1];
		$mail[$fields[$i]] = $fields[2];
		$IP[$fields[$i]] = $fields[3];
		$pseudo[$fields[$i]] = $fields[4];
	}
	echo "Enter your command: ";
	while ($code = fgets(STDIN))
	{
		eval($code);
		echo "Enter your command: ";
	}
	echo "\n";
}
?>
