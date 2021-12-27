<?php
if ($users = get_content($users_file, TRUE)) {
	if ($_GET['query'] == "changetype") {
		if ($_GET['id'] != 'admin') {
			if (get_user_type($_GET['id'], $users_file) == 'user')
				modify_user($_GET['id'], "type", "admin", $users_file);
			else if (get_user_type($_GET['id'], $users_file) == 'admin')
				modify_user($_GET['id'], "type", "user", $users_file);
		}
	} else if ($_GET['query'] == "deleteuser") {
		if ($_GET['id'] != 'admin')
			modify_user($_GET['id'], "login", "", $users_file);
	}
}

?>

<table id="users">
	<thead>
		<th>Login</th>
		<th>Name</th>
		<th>First name</th>
		<th>Email</th>
		<th>Type</th>
		<th>Promote</th>
		<th>Remove</th>
	</thead>
	<tbody>
		<?php
			if ($users)
			{
				foreach ($users as $user)
				{
					if ($user['login'] == '')
						continue;
					echo "<tr>";
					echo "<td>{$user['login']}</td>";
					echo "<td>{$user['last']}</td>";
					echo "<td>{$user['first']}</td>";
					echo "<td>{$user['email']}</td>";
					echo "<td>{$user['type']}</td>";
					if ($user['type'] == 'user')
						echo "<td><a href='admin.php?page=users&query=changetype&id={$user['login']}'>Make Admin</a></td>";
					else if ($user['type'] == 'admin')
						echo "<td><a href='admin.php?page=users&query=changetype&id={$user['login']}'>Remove Admin</a></td>";
					echo "<td><a href='admin.php?page=users&query=deleteuser&id={$user['login']}'>Remove</a></td>";
					echo "</tr>";
				}
			}
		?>
	</tbody>
</table>
