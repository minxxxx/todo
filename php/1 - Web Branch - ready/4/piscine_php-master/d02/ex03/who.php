#!/usr/bin/php
<?php
	$fd = fopen("/var/run/utmpx", 'r');
	$i = 0;
	while ($user = fread($fd, 628))
	{
		$user = unpack("a256zero/a4one/a32two/ithree/ifour/lfive", $user);
		if ($user[four] == "7")
		{
			$users[$i] = $user;
			$i++;
		}
	}
	date_default_timezone_set("Europe/Paris");
	asort($users);
	$users = array_values($users);
	echo $users[0][zero]." ";
	echo $users[0][two]."  ";
	echo date("M  j H:i", $users[0][five])."\n";
	unset($users[0]);
	foreach ($users as $elem)
	{
		echo $elem[zero]."      ";
		echo $elem[two]."  ";
		echo date("M j H:i", $elem[five])."\n";
	}
?>
