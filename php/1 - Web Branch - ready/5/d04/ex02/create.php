<?PHP
	function give_data()
	{
		if (!file_exists("../private"))
			mkdir("../private");
		if (!file_exists("../private/passwd"))
			return NULL;
		if (!($tab = file_get_contents("../private/passwd")))
			return NULL;
		if (!($tab = unserialize($tab)))
			return NULL;
		return $tab;
	}

	function is_in_tab($tab, $tab_to_add)
	{
		foreach ($tab as $cpy)
			if ($cpy['login'] === $tab_to_add['login'])
				return TRUE;
		return FALSE;
	}

	function lets_do_it()
	{
		if (!isset($_POST['submit']) || $_POST['submit'] !== "OK" || $_POST['login'] === "" || $_POST['passwd'] === "")
			return ("ERROR\n");
		$log = $_POST['login'];
		$mdp = hash("whirlpool", $_POST['passwd']);
		$tab_to_add = array("login" => $log, "passwd" => $mdp);
		if (!($tab = give_data()))
			$tab = array();
		else if (is_in_tab($tab, $tab_to_add))
				return ("ERROR\n");
		$tab[] = $tab_to_add;
		if (!file_put_contents("../private/passwd", serialize($tab)))
			return ("ERROR\n");
		return("OK\n");
	}
	echo(lets_do_it());
?>
