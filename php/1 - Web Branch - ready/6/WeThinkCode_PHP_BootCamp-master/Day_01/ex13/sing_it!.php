#!/usr/bin/php
<?php
if ($argc > 1)
{
	$demo = array("Why this demo ?");
	$song = array("Why this song ?");
	$really = array("really ?");
	$temp = $argv;
	if (strcmp($demo[0], $argv[1]) == 0)
		echo "To avoid people noticing this while going over
the subject briefly\n";
	else if (strcmp($song[0], $argv[1]) == 0)
		echo "Because we re all children inside\n";
	else if (strcmp($really[0], $argv[1]) == 0)
	{
		$i = rand(0, 1);
		if ($i == 0)
			echo "No it s because it s april s fool\n";
		else
			echo "Yeah we really are all children inside\n";
	}
}
?>