#!/usr/bin/php
<?PHP
if ($argc >= 3)
{
	foreach($argv as $k => $v)
	{
		if ($k > 1)
			if (preg_match("/^$argv[1]:(.*)/", $v, $array))
				$result = $array[1];
	}
	if ($result)
		echo $result.PHP_EOL;
}
?>
