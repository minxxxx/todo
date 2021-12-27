<?php
function ft_is_sort($tab)
{
	$array1 = $tab;
	$array2 = $tab;
	sort($array1);
	if ($array1 == $array2)
		return true;
	else
		return false;
}
?>
