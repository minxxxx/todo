<?php
function ft_split($str)
{
	$str = eregi_replace("[ \t]+", " ", $str);
	$ret = explode(" ", $str);
	sort($ret, SORT_STRING);
	return ($ret);
}
 ?>
