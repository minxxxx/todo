<?PHP
function ft_is_sort($array)
{
	$sorted = $array;
	sort($sorted);
	if (count(array_diff_assoc($array, $sorted)) == 0)
		return TRUE;
	return FALSE;
}
?>
