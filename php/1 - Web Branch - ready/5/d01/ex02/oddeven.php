#!/usr/bin/php
<?PHP

while (42)
{
	echo "Entrez un nombre: ";
	$line = fgets(STDIN);
	if (feof(STDIN) == TRUE)
		break ;
	$line = substr($line, 0, -1);
	if (is_numeric($line) == FALSE || $line[1] == 'b' || $line[1] == 'x' || $line[2] == 'b' || $line[2] == 'x')
		echo "'$line' n'est pas un chiffre".PHP_EOL;
	else
	{
		$lastnb = substr($line, -1, 1);
		if ($lastnb % 2 == 0)
			echo "Le chiffre $line est Pair".PHP_EOL;
		else
			echo "Le chiffre $line est Impair".PHP_EOL;
	}
}
echo PHP_EOL;
?>
