<?PHP
	function give_tab()
	{
		if (!file_exists("../private"))
			return NULL;
		if (!file_exists("../private/passwd"))
			return NULL;
		if (!($tab = file_get_contents("../private/passwd")))
			return NULL;
		if (!($tab = unserialize($tab)))
			return NULL;
		return $tab;
	}

	function search_and_modify_passwd(&$tab, $hashold, $hashnew)
	{
		foreach ($tab as &$ptr)
		{
			if ($ptr["login"] === $_POST["login"])
			{
				if ($ptr["passwd"] === $hashold)
				{
					$ptr["passwd"] = $hashnew;
					return TRUE;
				}
				return FALSE;
			}
		}
		return FALSE;
	}

	function lets_do_it()
	{
		if (!isset($_POST["submit"]) || $_POST["submit"] !== "OK" || $_POST["login"] === "" || $_POST["oldpw"] === "" || $_POST["newpw"] === "")
			return ("ERROR\n");
		$oldmdp = hash("whirlpool", $_POST["oldpw"]);
		$newmdp = hash("whirlpool", $_POST["newpw"]);
		if (!($tab = give_tab()))
			return ("ERROR\n");
		if (!search_and_modify_passwd($tab, $oldmdp, $newmdp))
			return ("ERROR\n");
		if (!file_put_contents("../private/passwd", serialize($tab)))
		 	return ("ERROR\n");
		return("OK\n");
	}
	echo(lets_do_it());
?>
