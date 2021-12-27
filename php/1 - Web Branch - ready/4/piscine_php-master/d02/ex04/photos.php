#!/usr/bin/php
<?php
if ($argc == 2)
{
	if (!filter_var($argv[1], FILTER_VALIDATE_URL))
		exit;
	$folder = str_replace("http://", "", $argv[1]);
	mkdir($folder);
	$file1 = file_get_contents("http://www.42.fr/wp-content/themes/42/images/42_logo_black.svg");
	$file2 = file_get_contents("http://www.42.fr//images/home_big.jpg");
	$path1 = $folder."/42_logo_black.svg";
	$path2 = $folder."/home_big.jpg";
	file_put_contents($path1, $file1);
	file_put_contents($path2, $file2);
}
?>
