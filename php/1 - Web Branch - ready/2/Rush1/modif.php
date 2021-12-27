<?php
include('config.php');

function modif_check($file, $post)
{
	if (!(file_exists($file))) {
		redirect("Location: edit.php?s=DB Error");
		return (false);
	}
	if ($post['submit'] != "OK") {
		redirect("Location: edit.php?s=KO");
		return (false);
	}
	if (!auth($post['login'], $post['passwd'], $file)) {
		redirect("Location: edit.php?s=Mot de passe invalide");
		return (false);
	}
	return (true);
}

function update_card($post, $users_file)
{
	$user = get_user_card($post['login'], $users_file);

	if (!$user) {
		exit("get_user_card failed");
	}
	if ($post['fn'] != "") {
		$user['first'] = $post['fn'];
	}
	if ($post['ln'] != "") {
		$user['last'] = $post['ln'];
	}
	if ($post['newpw'] == "") {
		$user['passwd'] = hash("sha256", $post['passwd']);
	} else {
		$user['passwd'] = hash("sha256", $post['newpw']);
	}
	if ($post['email'] != "") {
		$user['email'] = $post['email'];
	}
	if ($post['address'] != "") {
		$user['address'] = $post['address'];
	}
	return ($user);
}

if (modif_check($users_file, $_POST)) {

	$data = get_content($users_file, TRUE);
	foreach ($data as $i => $elem) {
		if ($elem['login'] == $_POST['login']) {
			$data[$i] = update_card($_POST, $users_file);
			break ;
		}
	}
	file_put_contents($users_file, serialize($data));
	if ($_POST['del'] == "yes") {
		$data = get_content($users_file, TRUE);
		foreach ($data as $i => $elem) {
			if ($elem['login'] == $_POST['login']) {
				$data[$i]['login'] = "";
				file_put_contents($users_file, serialize($data));
				break ;
			}
		}
		exit(header('Location: logout.php'));
	}
	redirect('edit.php');
}
?>
