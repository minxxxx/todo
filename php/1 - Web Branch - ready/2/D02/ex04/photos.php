#!/usr/bin/php
<?php
if ($argc != 2)
	exit();

$url = $argv[1];
preg_match("!(://)?([a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3})!i", $url, $url_clean);
$url_clean = $url_clean[2];

$fd = curl_init();
curl_setopt($fd, CURLOPT_URL, $url);
curl_setopt($fd, CURLOPT_RETURNTRANSFER, TRUE);
//curl_setopt($fd, CURLOPT_BINARYTRANSFER, TRUE);
$str = curl_exec($fd);
curl_close($fd);

preg_match_all("/<img .*?>/si", $str, $images);
$img_links = array();
foreach($images[0] as $image)
{
	preg_match("/src=\"(.*?)\"/is", $image, $link);
	array_push($img_links, $link[1]);
}
foreach($img_links as $link)
{
	preg_match("![^/]*$!", $link, $img_name);
	$img_name = $img_name[0];
	if (!file_exists($url_clean))
		mkdir($url_clean);
	if (preg_match("/(http|www)/", $link))
		copy($url, $url_clean."/".$img_name);
	else
		copy($url."/".$link, $url_clean."/".$img_name);
}
?>
