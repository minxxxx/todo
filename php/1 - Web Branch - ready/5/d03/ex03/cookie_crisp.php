<?PHP
if (isset($_GET["action"]) && $_GET["action"] == "set")
	setcookie($_GET["name"], $_GET["value"], time()+2592000);
else if (isset($_GET["action"]) && $_GET["action"] == "get" && $_GET["name"] && $_COOKIE[$_GET["name"]])
	echo $_COOKIE[$_GET["name"]]."\n";
else if (isset($_GET["action"]) && $_GET["action"] == "del")
	setcookie($_GET["name"], $_GET["value"]);
?>
