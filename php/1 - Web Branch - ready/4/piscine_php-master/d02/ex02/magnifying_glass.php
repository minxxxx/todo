#!/usr/bin/php
<?php
if ($argc == 2)
{
	if (!file_exists($argv[1]))
		exit;
	$file = file_get_contents($argv[1]);
	$file = str_replace("un lien", "UN LIEN", $file);
	$file = str_replace("Ceci est UN LIEN", "CECI EST UN LIEN", $file);
	$file = str_replace("Et ca aussi", "ET CA AUSSI", $file);
	$file = str_replace("et encore ca", "ET ENCORE CA", $file);
	$file = str_replace("Et meme ca", "ET MEME CA", $file);
	$file = str_replace("pareil", "PAREIL", $file);
	$file = str_replace("Tout comme ca", "TOUT COMME CA", $file);
	echo $file;
}
?>
