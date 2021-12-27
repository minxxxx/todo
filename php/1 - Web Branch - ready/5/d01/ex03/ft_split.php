<?PHP

function ft_split($s)
{
	$s = trim($s, " \t");
	$s = preg_replace("/[ \t]+/", " ", $s);
	if (strlen($s) === 0)
		return (array());
	$s = explode(" ", $s);
	sort($s);
	return ($s);
}
?>
