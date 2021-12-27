#!/usr/bin/php
<?php
function getData($av1)
{
	$id = curl_init();
	curl_setopt($id, CURLOPT_URL, $av1);
	curl_setopt($id, CURLOPT_RETURNTRANSFER, 1);
	$data = curl_exec($id);
	curl_close($id);
	return $data;
}

function contain_img($data)
{
	if (preg_match_all('/<'.'\s*img'.'[^>]*'.'\ssrc=([\"\'])'.'([^\1]+?)'.'\1'.'/i',$data, $imgs_url) == 0)
		return false;
	return $imgs_url[count($imgs_url) - 1];
}

function dl_img($img_url, $path)
{
	if	(($data = getData($img_url)) === false)
		return ;
	if (!($fd = fopen($path."/".basename($img_url), 'w')))
		return ;
	fwrite($fd, $data);
	fclose($fd);
}

if ($argc == 2)
{
	if ($argv[1][strlen($argv[1]) - 1] == '/')
		$argv[1] = substr($argv[1], 0, strlen($argv[1]) - 1);
	if (($data = getData($argv[1])) === false)
		echo "bad url".PHP_EOL;
	else if (($imgs_url = contain_img($data)) == false)
		echo "no img".PHP_EOL;
	else
	{
		$path = "./".preg_replace('#^https?://#', '', $argv[1]);
		if (!is_dir($path))
			if (!mkdir($path))
				exit("error mkdir...");
		foreach ($imgs_url as $k => $v)
		{
			if (preg_match('/^https?:\/\//', $v) === 0)
				$imgs_url[$k] = $argv[1].$imgs_url[$k];
			dl_img($imgs_url[$k], $path);
		}
	}
}
?>
