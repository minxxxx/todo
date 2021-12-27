<?php
	function auth($login, $passwd)
	{
		$s_hash = hash("whirlpool", $passwd);

		$db_server = "localhost";
		$db_username = "root";
		$db_passwd = "bakcWO0I2BBhTF4X";
		$db_name = "rush00";

		$conn = mysqli_connect($db_server, $db_username, $db_passwd, $db_name);
		if (!$conn)
		{
			echo 'Could not connect: ' . mysqli_connect_error();
			return false;
		}

		$db_result = mysqli_query($conn, "SELECT * FROM `users`") or trigger_error("Query Failed");
		if ($db_result)
		{
			while ($db_row = mysqli_fetch_assoc($db_result))
			{
				if ($db_row['Username'] === $login && $db_row['Passwd'] === $s_hash)
				{
					mysqli_free_result($db_result);
					mysqli_close($conn);
					return (true);
				}
			}
		}
		mysqli_free_result($db_result);
		mysqli_close($conn);
		return (false);
	}

	function get_access($login, $passwd)
	{
		$s_hash = hash("whirlpool", $passwd);

		$db_server = "localhost";
		$db_username = "root";
		$db_passwd = "bakcWO0I2BBhTF4X";
		$db_name = "rush00";

		$conn = mysqli_connect($db_server, $db_username, $db_passwd, $db_name);
		if (!$conn)
		{
			echo 'Could not connect: ' . mysqli_connect_error();
			return false;
		}

		$db_result = mysqli_query($conn, "SELECT * FROM `users`") or trigger_error("Query Failed");
		if ($db_result)
		{
			while ($db_row = mysqli_fetch_assoc($db_result))
			{
				if ($db_row['Username'] === $login && $db_row['Passwd'] === $s_hash && $db_row['Level'] === 'admin')
				{
					mysqli_free_result($db_result);
					mysqli_close($conn);
					return (1);
				}
			}
		}
		mysqli_free_result($db_result);
		mysqli_close($conn);
		return (0);
	}

	function check_user($login)
	{
		$db_server = "localhost";
		$db_username = "root";
		$db_passwd = "bakcWO0I2BBhTF4X";
		$db_name = "rush00";

		$conn = mysqli_connect($db_server, $db_username, $db_passwd, $db_name);
		if (!$conn)
		{
			echo 'Could not connect: ' . mysqli_connect_error();
			return false;
		}

		$db_result = mysqli_query($conn, "SELECT * FROM `users`") or trigger_error("Query Failed");
		if ($db_result)
		{
			while ($db_row = mysqli_fetch_assoc($db_result))
			{
				if ($db_row['Username'] === $login)
				{
					mysqli_free_result($db_result);
					mysqli_close($conn);
					return (true);
				}
			}
		}
		mysqli_free_result($db_result);
		mysqli_close($conn);
		return (false);
	}
?>