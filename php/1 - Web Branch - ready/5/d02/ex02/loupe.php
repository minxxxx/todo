#!/usr/bin/php
<?PHP

function ft_replace3($array)
{
	return ($array[1].strtoupper($array[3]).$array[5]);
}

function ft_replace2($array)
{
	$pattern2 = '/(title\s*=\s*([\"\']))((:?(?!\2).)*)(\2)/si';
	$ret2 = preg_replace_callback($pattern2, "ft_replace3", $array[2]);
	return (strtoupper($array[1]).$ret2);
}

function ft_replace($array)
{
	$ret1 = preg_replace_callback('/(title\s*=\s*([\"\']))((:?(?!\2).)*)(\2)/si', "ft_replace3", $array[1]);
	$ret2 = preg_replace_callback("/([^<]+)(<[^>]*>)*/is", "ft_replace2", $array[2]);
	return ($ret1.$ret2.$array[3]);
}

if ($argc > 1)
{
	$pattern = "/(<a\s*[^>]*>)(.*?)(<\s*\/\s*a\s*>)/is";
	echo preg_replace_callback($pattern, "ft_replace", file_get_contents($argv[1]));
}
?>
