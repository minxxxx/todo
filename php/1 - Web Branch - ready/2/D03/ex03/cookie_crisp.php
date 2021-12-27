<?php
if ($_GET['action'] == 'get' || $_GET['action'] == 'set' || $_GET['action'] == 'del')
{
	$action = $_GET['action'];

	if($_GET['value'])
		$value = $_GET['value'];

	if($_GET['name'])
	{
		$name = $_GET['name'];
		if($action == 'get')
			echo $_COOKIE[$name]."\n";
		else if ($action == 'set' && $value)
			setcookie($name, $value, time()+3600);
		else if ($action == 'del')
			setcookie($name, $value, time()-3600);
	}
}
?>
