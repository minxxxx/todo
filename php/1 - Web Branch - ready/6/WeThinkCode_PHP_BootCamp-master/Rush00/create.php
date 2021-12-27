<?php
	include('auth.php');

	$s_title = $_POST['title'];
	$s_firstname = $_POST['firstname'];
	$s_lastname = $_POST['lastname'];
	$s_email =$_POST['email'];

	$s_username = $_POST['login'];
	$s_passwd = $_POST['passwd'];
	$s_confpasswd = $_POST['confpasswd'];

	if ($_POST['submit'] === "OK")
	{
		if (check_user($s_username))
			echo "Username already Exits";
		elseif ($s_passwd !== $s_confpasswd)
			echo "Passwords do not match";
		else
		{
			$s_hash = hash("whirlpool", $s_passwd);

			$db_server = "localhost";
			$db_username = "root";
			$db_password = "bakcWO0I2BBhTF4X";
			$db_name = "rush00";

			$db_conn = mysqli_connect($db_server, $db_username, $db_password, $db_name);
			if (!db_conn)
				echo "Failed to connect to database: " . mysqli_connect_error();
			else
			{
				$db_query = "INSERT INTO users (Title, FirstName, LastName, Email, Username, Passwd, Level) VALUES ('" . $s_title . "', '" . $s_firstname . "', '" . $s_lastname . "', '" . $s_email . "', '" . $s_username . "', '" . $s_hash . "', 'member');";
				
				if (mysqli_query($db_conn, $db_query))
				{
					mysqli_close($db_conn);
					header("Location: login.php");
				}
				else
					echo "Failed to create account.";
				mysqli_close($db_conn);
			}
		}
	}
?>

<!DOCTYPE html>
<html>
<body>
	<h1>Create Account</h1>
	<form action="create.php" method="POST">
		<label for="title">Title</label>
		<input type="input" name="title" required="true"/>
		<label for="firstname">First Name:</label>
		<input type="input" name="firstname"/>
		<label for="lastname">Surname:</label>
		<input type="input" name="lastname" required="true" />
		<label for="email">E-mail:</label>
		<input type="input" name="email" required="true">
		<br/>
		<label for="login">Username: </label>
		<input type="input" name="login" required="true" />
		<label for="passwd">Password: </label>
		<input type="password" name="passwd" required="true" />
		<label for="confpasswd">Confirm Password: </label>
		<input type="password" name="confpasswd" required="true" />
		<input type="submit" name="submit" value="OK"/>
	</form>
	<br/>
	<a href="login.php">[back]</a>
</body>
</html>