#!/usr/bin/php
<?php
if ($argc == 2)
{
	$argv[1] = str_replace(" ", "", $argv[1]);
	if (substr_count($argv[1], "+") == 1)
	{
		$syntax = str_replace("+", "", $argv[1]);
		$syntax = str_replace("-", "", $syntax);
		if (is_numeric($syntax))
		{
			$array = explode("+", $argv[1]);
			$result = $array[0] + $array[1];
			echo "$result\n";
		}
		else
			echo "Syntax Error\n";
	}
	else if (substr_count($argv[1], "*") == 1)
	{
		$syntax = str_replace("*", "", $argv[1]);
		$syntax = str_replace("-", "", $syntax);
		if (is_numeric($syntax))
		{
			$array = explode("*", $argv[1]);
			$result = $array[0] * $array[1];
			echo "$result\n";
		}
		else
			echo "Syntax Error\n";
	}
	else if (substr_count($argv[1], "/") == 1)
	{
		$syntax = str_replace("/", "", $argv[1]);
		$syntax = str_replace("-", "", $syntax);
		if (is_numeric($syntax))
		{
			$array = explode("/", $argv[1]);
			if ($array[1] == '0')
				echo "Syntax Error\n";
			else
			{
				$result = $array[0] / $array[1];
				echo "$result\n";
			}
		}
		else
			echo "Syntax Error\n";
	}
	else if (substr_count($argv[1], "%") == 1)
	{
		$syntax = str_replace("%", "", $argv[1]);
		$syntax = str_replace("-", "", $syntax);
		if (is_numeric($syntax))
		{
			$array = explode("%", $argv[1]);
			if ($array[1] == '0')
				echo "Syntax Error\n";
			else
			{
				$result = $array[0] % $array[1];
				echo "$result\n";
			}
		}
		else
			echo "Syntax Error\n";
	}
	else if (($a = substr_count($argv[1], "-")) == 1 || ($a = substr_count($argv[1], "-")) == 2 || ($a = substr_count($argv[1], "-")) == 3)
	{
		if ($argv[1][0] == '-')
			$b = 1;
		$syntax = str_replace("-", "", $argv[1]);
		if (is_numeric($syntax))
		{
			$array = explode("-", $argv[1]);
			foreach ($array as $key => $value)
			{
				if (!is_numeric($array[$key]))
					unset($array[$key]);
			}
			$array = array_values($array);
			if ($a == 2 && $b == 1)
				$array[0] = -$array[0];
			else if ($a == 2 && $b == 0)
				$array[1] = -$array[1];
			else if ($a == 3)
			{
				$array[0] = -$array[0];
				$array[1] = -$array[1];
			}
			$result = $array[0] - $array[1];
			echo "$result\n";
		}
		else
			echo "Syntax Error\n";
	}
	else
		echo "Syntax Error\n";
}
else
	echo "Incorrect Parameters\n";
?>
