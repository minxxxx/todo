<?php
if ($_POST["login"] && $_POST["passwd"] && $_POST["submit"] == "OK")
{
	if (!file_exists("../private"))
		mkdir("../private");
	$i = 0;
	if (file_exists("../private/passwd"))
	{
		$accounts = unserialize(file_get_contents("../private/passwd"));
		foreach ($accounts as $elem)
		{
			if ($elem["login"] == $_POST["login"])
				exit("ERROR\n");
			$i++;
		}
	}
	$accounts[$i]["login"] = $_POST["login"];
	$accounts[$i]["passwd"] = hash("Whirlpool", $_POST["passwd"]);
	file_put_contents("../private/passwd", serialize($accounts));
	echo "OK\n";
}
else
	echo "ERROR\n";
?>
