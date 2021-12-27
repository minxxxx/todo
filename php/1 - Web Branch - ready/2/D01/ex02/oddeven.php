#!/usr/bin/php
<?php

while (42)
{
	$prompt = fopen("php://stdin", "r");
	echo "Entez un nombre: ";
	$number = fgets($prompt, 50);
	$number = trim($number);
	if (ord($number) == 0)
	{
		fclose($prompt);
		break;
	}
	if (is_numeric($number) && $number > 0)
	{
		$number = intval($number);
		if ($number % 2 == 0)
			echo "Le chiffre $number est Pair\n";
		else
			echo "Le chiffre $number est Impair\n";
	}
	else
	{
		echo "'$number' n'est pas un chiffre\n";
	}
}
?>
