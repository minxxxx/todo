<?PHP
	function auth($login, $passwd)
	{
		$seria_file = "../private/passwd";
		$seria_cont = @file_get_contents($seria_file);
		if (!$seria_cont)
			return FALSE;
		$validate_author = unserialize($seria_cont);
		$hashed_password = hash("whirlpool", $passwd); #SHA-512/256
		foreach ($validate_author as $element)
		{
			if ($element['login'] === $login && $element['passwd'] === $hashed_password)
				return TRUE;
		}
		return FALSE;
	}
?>
