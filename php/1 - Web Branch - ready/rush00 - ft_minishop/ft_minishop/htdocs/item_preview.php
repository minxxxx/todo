<?php

$request = 'SELECT id, name, price FROM `items` ORDER BY RAND() LIMIT 0,1;';
$result = mysqli_query($sql_ptr, $request);
if (mysqli_num_rows($result) > 0)
{
	$itemPage = "/item.php?id=";
	$row = mysqli_fetch_assoc($result);
	$ipath = "";
	if (!isset($row['id']) ||
		!($ipath = "$imgs_path/".$row['id'].'.jpg') ||
		!file_exists($_SERVER['DOCUMENT_ROOT']."$ipath") ||
		($dat = getimagesize($_SERVER['DOCUMENT_ROOT'].$ipath)) === false ||
			$dat['mime'] !== 'image/jpeg')
				$ipath = "$imgs_path/fallback.jpg";
	echo '<div class="cat-item-box"><div>'.
		'<a href="'.$itemPage.$row['id'].'">'.
		'<img src="'.$ipath.'" />'.
		'<div>'.$row['name'].' '.
		money_format('%!10.2n &euro;', (float)$row['price'] / 100.).
		'</div>'.
		"</a></div></div>";
}

?>
