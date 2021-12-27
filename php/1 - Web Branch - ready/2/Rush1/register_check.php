<?php
session_start();
include('config.php');

function registrator($file, $post, $session)
{
	foreach($post as $key => $elem) {
		if ($key == "spam" || $key == "terms") {
			continue ;
		} else if ($elem == "") {
			return (false);
		}
	}
	if ($post['submit'] != "OK") {
		echo $post['submit']."\n";
		return (false);
	}
	if (!($post['terms'] == "agreed")) {
		header('Location: register.php?s=You have to agree our policy to proceed');
		die();
	}
	if (intval($session['captcha']) !== intval($post['captcha'])) {
		header('Location: register.php?s=Captcha failed');
		die() ;
	}
	if ($post['passwd'] != $post['repasswd']) {
		header('Location: register.php?s=Password are not the same');
		die() ;
	}
	if (already_exists($file, "login", $post['login'])) {
		header('Location: register.php?s=User already exists');
		die() ;
	}
	return (true);
}

$file = "private/passwd";
$encrypted = hash('sha256', $_POST['passwd']);

if (registrator($users_file, $_POST, $_SESSION)) {
	$data = get_content($file, FALSE);
	if (count($data) == 0)
		$user_type = "admin";
	else
		$user_type = "user";
	$new = array("login" => $_POST['login'],
		"first" => $_POST['fn'],
		"last" => $_POST['ln'],
		"passwd" => $encrypted,
		"email" => $_POST['email'],
		"address" => $_POST['address'],
		"type" => $user_type);
	$data[] = $new;
	file_put_contents($file, serialize($data));
	header('Location: login.php');
}
else {
	header('Location: register.php?s=You have to fill everything');
	echo "Something Happened\n";
}
?>
