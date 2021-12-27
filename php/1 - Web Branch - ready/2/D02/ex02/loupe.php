#!/usr/bin/php
<?php
if ($argc != 2)
	exit();
$content = file_get_contents($argv[1]);

function a_to_upper($matched)
{
	$res = $matched[0];
	$res = preg_replace_callback("/title=\"(.*?)\"/is", function ($text) { return "title=\"".strtoupper($text[1])."\""; }, $res);
	$res = preg_replace_callback("/>.+?</s", function ($text) { return strtoupper($text[0]); }, $res);
	return $res;
}

$content = preg_replace_callback("/<a .*?<\/a>/is", "a_to_upper", $content);
echo $content;
?>
