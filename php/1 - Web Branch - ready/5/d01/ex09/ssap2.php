#!/usr/bin/php
<?PHP

function ft_isdigit($c)
{
	if ($c >= '0' && $c <= '9')
		return TRUE;
	return FALSE;
}

function ft_isalpha($c)
{
	if ($c >= 'a' && $c <= 'z')
		return TRUE;
	return FALSE;
}

function ft_cmp($c1, $c2)
{
	if ($c1 > $c2)
		return 1;
	return -1;
}

function cmp_chars($c1, $c2)
{
	if (ft_isalpha($c1))
	{
		if (ft_isalpha($c2))
			return ft_cmp($c1, $c2);
		return -1;
	}
	if (ft_isdigit($c1))
	{
		if (ft_isalpha($c2))
			return 1;
		if (ft_isdigit($c2))
			return ft_cmp($c1, $c2);
		return -1;
	}
	if (ft_isalpha($c2) || ft_isdigit($c2))
		return 1;
	return ft_cmp($c1, $c2);
}

function ft_ssap($a, $b)
{
	$a = strtolower($a);
	$b = strtolower($b);
	$i = 0;
	while ($a[$i] && $b[$i])
	{
		if ($a[$i] != $b[$i])
			return (cmp_chars($a[$i], $b[$i]));
		$i++;
	}
	if (strlen($a) > strlen($b))
		return (1);
	elseif (strlen($a) < strlen($b))
		return (-1);
	else
		return (0);
}

function ft_sort($tab)
{
	$bef_last = count($tab) - 1;
	$swaped = true;
	while ($swaped)
	{
		$i = -1;
		$swaped = false;
		while (++$i < $bef_last)
		{
			if (ft_ssap($tab[$i], $tab[$i + 1]) > 0)
			{
				$swaped = true;
				$swap = $tab[$i];
				$tab[$i] = $tab[$i + 1];
				$tab[$i + 1] = $swap;
			}
		}
	}
	return $tab;
}

function ft_split($s)
{
	$s = trim($s, " ");
	$s = preg_replace('/\ \ +/', ' ', $s);
	return explode(" ", $s);
}

$tab = array();
foreach($argv as $k => $v)
	if ($k > 0)
		$tab = array_merge($tab, ft_split($v));
$tab = ft_sort($tab);
foreach($tab as $k => $v)
{
	if ($v != "")
		echo $v.PHP_EOL;
}
?>
