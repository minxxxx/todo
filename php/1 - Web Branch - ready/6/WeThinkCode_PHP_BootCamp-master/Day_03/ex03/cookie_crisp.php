<?PHP
if ($_GET["action"] === "set")
{
	setcookie($_GET["name"], $_GET["value"], time() + (86400 * 30));
}
else if ($_GET["action"] === "get")
{
	if ($_COOKIE[$_GET["name"]] != NULL)
		echo $_COOKIE[$_GET["name"]] . "\n";
}
else if ($_GET["action"] === "del")
{
	setcookie($_GET["name"], "should not exist", 1);
}
?>
