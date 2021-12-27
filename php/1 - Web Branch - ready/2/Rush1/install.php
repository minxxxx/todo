<?php
if (!file_exists('private'))
	mkdir('private');

if (!file_exists('img'))
	mkdir('img');

if (!file_exists('private/passwd'))
{
	$fd = fopen("private/passwd", "w");
	fclose($fd);

	$admin = array(
		"login" => "admin",
		"first" => "admin",
		"last" => "admin",
		"passwd" => hash("sha256", "admin"),
		"email" => "admin@admin.com",
		"address" => "admin",
		"type" => "admin"
	);
	file_put_contents("private/passwd", serialize(array($admin)));
}

function generate_random_id()
{
	$i = 0;
	$res = "";

	while ($i < 12)
	{
		if ($i % 2 == 0)
			$char = chr(rand(97, 122));
		else
			$char = rand(0, 9);
		$res = $res.$char;
		$i++;
	}
	return $res;
}

if (!file_exists('private/categories'))
{
	$fd = fopen("private/categories", "w");
	fclose($fd);
	file_put_contents("private/categories", serialize(array("Skate","Snowboard","Roller")));
}


$p1 = array(
	"id" => generate_random_id(),
	"name" => "5BORO CINCO BARRIOS",
	"photo" => "img/5boros.jpg",
	"description" => "5BORO CINCO BARRIOS CRUISER SMALL",
	"quantity" => 50,
	"price" => 70,
	"category" => "Skate"
);

$p2 = array(
	"id" => generate_random_id(),
	"name" => "Cliche Sammy",
	"photo" => "img/cliche.jpg",
	"description" => "CLICHÉ SAMMY WINTER MR MEN PAINT PEN (RESIN 7)",
	"quantity" => 90,
	"price" => 65,
	"category" => "Skate"
);

$p3 = array(
	"id" => generate_random_id(),
	"name" => "Apo Iconic Sage",
	"photo" => "img/apo.jpg",
	"description" => "Pack Iconic Sage Kotsenburg  - APO Fixation Fifty Black  - DRAKE",
	"quantity" => 20,
	"price" => 365,
	"category" => "Snowboard"
);

if (!file_exists('private/products'))
	file_put_contents("private/products", serialize(array($p1, $p2, $p3)));

header('Location: login.php');

?>
