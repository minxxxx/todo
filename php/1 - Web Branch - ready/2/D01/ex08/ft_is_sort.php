#!/usr/bin/php
<?php
function ft_is_sort($tab)
{
	$param = $tab;
	sort($tab);
	if ($tab === $param)
		return (1);
	else
		return (0);
}
?>
