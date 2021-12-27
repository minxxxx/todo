<?php
if ($_POST["login"] && $_POST["oldpw"] && $_POST["newpw"] && $_POST["submit"] == "OK")
{
	if (!file_exists("../private/passwd"))
		exit("ERROR\n");
	$accounts = unserialize(file_get_contents("../private/passwd"));
	$i = 0;
	while ($accounts[$i])
	{
		if ($_POST["login"] == $accounts[$i]["login"])
		{
			if (hash("Whirlpool", $_POST["oldpw"]) == $accounts[$i]["passwd"])
			{
				$accounts[$i]["passwd"] = hash("Whirlpool", $_POST["newpw"]);
				file_put_contents("../private/passwd", serialize($accounts));
				echo "OK\n";
				exit;
			}
		}
		$i++;
	}
	echo "ERROR\n";
}
else
	echo "ERROR\n";
?>
