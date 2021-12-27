<?PHP
	function error()
	{
		echo "ERROR\n";
		exit;
	}

	if ($_POST['submit'] !== "OK")
		error();
	if (!$_POST["login"] || !$_POST["passwd"])
		error();

	$serialized_path = "../private/";
	$serialized_file = $serialized_path . "passwd";
	if (file_exists($serialized_file))
		$authentication = unserialize(file_get_contents($serialized_file));

	$largest_key = 0;
	foreach ($authentication as $key => $element)
	{
		if ($element["login"] === $_POST["login"])
			error();
		if ($key > $largest_key)
			$largest_key = $key;
	}

	$authentication[$largest_key + 1]["login"] = $_POST["login"];
	$authentication[$largest_key + 1]["passwd"] = hash("SHA-512/256", $_POST["passwd"]); #whirlpool

	@mkdir($serialized_path);
	file_put_contents($serialized_file, serialize($authentication));
	echo "OK\n";
?>
