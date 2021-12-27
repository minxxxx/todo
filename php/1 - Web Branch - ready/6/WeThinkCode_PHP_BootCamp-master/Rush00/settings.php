<?php
	session_start();

	if ($_SESSION['logged_on'] == null || $_SESSION['logged_on'] == "")
	{
		echo "<h1>" . "Error: Not logged in" . "</h1";
		return;
	}

	if ($_POST['submit'] === "Submit Password")
	{
		$s_username = $_POST['login'];
		$s_oldpw = $_POST['oldpw'];
		$s_newpw = $_POST['newpw'];
		$s_conf = $_POST['confpw'];

		if ($s_newpw !== $s_conf)
		{
			echo "Passwords do not match.";
			return ;
		}

		$db_server = "localhost";
		$db_username = "root";
		$db_password = "bakcWO0I2BBhTF4X";
		$db_name = "rush00";

		$db_conn = mysqli_connect($db_server, $db_username, $db_password, $db_name);
		if (!db_conn)
		{
			echo "Failed to Connect to database";
			return;
		}

		$s_hash = hash("whirlpool", $s_newpw);

		$db_query = "UPDATE `users` SET passwd='" . $s_hash . "' WHERE Username='" . $s_username . "'";
		if (mysqli_query($db_conn, $db_query))
			echo "Updated Successfully";
		else
			echo "Failed to Update";

		mysqli_close($db_conn);
		echo "Changing password";
	}
?>

<!DOCTYPE html>
<html>
<head>
	<style type="text/css">
		h1 {
			color: #bdbdbd;
		}
	</style>
</head>
<body>
	<h1> 1) Change Password</h1>
	<form action="settings.php" method="POST">
		<label for="login">Username:</label>
		<input type="input" name="login" required="true" />

		<label for="newpw">Old Password:</label>
		<input type="password" name="oldpw" required="true" />
<br/>
<br/>
		<label for="oldpw">New Password:</label>
		<input type="password" name="newpw" required="true" />
		<label for="confoldpw">Confirm New Pass</label>
		<input type="password" name="confpw" required="true"/>

		<input type="submit" name="submit" value="Submit Password"/>
	</form>
</body>
</html>