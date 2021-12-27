#!/usr/bin/php
<?php
if ($argc > 2)
{
	$key = $argv[1];
	unset($argv[0], $argv[1]);
	foreach ($argv as $elem)
	{
		$pair = explode(":", $elem);
		if ($key == $pair[0])
			$result = $pair[1];
	}
	if ($result)
		echo $result."\n";
}
?>
