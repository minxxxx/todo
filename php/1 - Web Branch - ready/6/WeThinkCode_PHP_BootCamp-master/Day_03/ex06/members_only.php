<?php

$valid_passwords = array ("zaz" => "Ilovemylittleponey");
$valid_users = array_keys($valid_passwords);

$user = $_SERVER['PHP_AUTH_USER'];
$pass = $_SERVER['PHP_AUTH_PW'];

$validated = (in_array($user, $valid_users)) && ($pass == $valid_passwords[$user]);

if ($validated) {
	header('Content-Type: text/html');
	echo "<html><body>\nHello Zaz<br />\n<img src='data:image/png;base64,";
	echo base64_encode(file_get_contents("../img/42.png", "png"));
	echo "'>\n</body></html>\n";
}
else
{
	header("HTTP/1.0 401 Unauthorized");
	header("Date: Tue, 26 Mar 2013 09:42:42 GMT");
	header("WWW-Authenticate: Basic realm=''Member area''");
	header_remove("Authentication problem. Ignoring this.");
	echo "<html><body>That area is accessible for members only</body></html>";
}

?>
