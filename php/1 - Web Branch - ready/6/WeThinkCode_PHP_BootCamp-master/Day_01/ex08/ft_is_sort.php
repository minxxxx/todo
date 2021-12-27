<?php
function ft_is_sort($str)
{
  $count = 0;
	$temp = $str;
	sort($str);
	foreach ($str as $elem)
	{
		if ($elem != $temp[$count])
			return (0);
		$count++;
	}
	return (1);
}
?>
