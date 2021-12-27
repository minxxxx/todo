<?PHP
	function error()
	{
		echo "ERROR\n";
		exit;
	}

	if ($_POST['submit'] !== "OK")
		error();
	if (!$_POST["login"] || !$_POST["oldpw"] || !$_POST["newpw"])
		error();

	$serialized_file = "../private/passwd";
	$serialized_contents = @file_get_contents($serialized_file);
	if (!$serialized_contents)
		error();
	$authentication = unserialize($serialized_contents);
	foreach ($authentication as $key => $element)
	{
		if ($element["login"] === $_POST["login"])
		{
			$found_key = $key;
			break;
		}
	}
	if (!isset($found_key) || $authentication[$found_key]['passwd'] !== hash("SHA-512/256", $_POST['oldpw'])) #whirlpool
		error();

	$authentication[$found_key]["passwd"] = hash("SHA-512/256", $_POST["newpw"]); #whirlpool
	file_put_contents($serialized_file, serialize($authentication));
	echo "OK\n";
?>
