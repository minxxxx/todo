<?php
function auth($login, $passwd)
{
	if (!file_exists("../private/passwd"))
		return FALSE;
	if (!$login || !$passwd)
		return FALSE;
	$accounts = unserialize(file_get_contents("../private/passwd"));
	foreach ($accounts as $elem)
	{
		if ($login == $elem["login"])
		{
			if (hash("Whirlpool", $passwd) == $elem["passwd"])
				return TRUE;
		}
	}
	return FALSE;
}
?>
