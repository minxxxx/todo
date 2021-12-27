<?PHP
function auth($login, $passwd)
{
	if (!file_exists("../private"))
		return FALSE;
	if (!file_exists("../private/passwd"))
		return FALSE;
	if (!($tab = file_get_contents("../private/passwd")))
		return FALSE;
	if (!($tab = unserialize($tab)))
		return FALSE;
	$hashedpw = hash("whirlpool", $passwd);
	foreach ($tab as &$ptr)
	{
		if ($ptr["login"] === $login)
		{
			if ($ptr["passwd"] === $hashedpw)
				return TRUE;
			return FALSE;
		}
	}
	return FALSE;
}
