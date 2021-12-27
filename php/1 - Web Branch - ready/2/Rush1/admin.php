<?php
session_start();
include('config.php');

if (get_user_type($_SESSION['whoami'], $users_file) !== 'admin')
	redirect("index.php");

?>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>Add Product</title>
		<link rel="stylesheet" href="css/admin.css" media="screen" charset="utf-8">
	</head>
	<body>
		<nav>
				<a href="index.php">Index</a>
				<a href="admin.php?page=products">Products</a>
				<a href="admin.php?page=users">Users</a>
		</nav>
		<div id="main">
			<?php
			if ($_GET['page'] == 'products')
				include('admin/admin_products.php');
			else if ($_GET['page'] == 'users')
				include('admin/admin_users.php');
			else
				redirect("admin.php?page=products");
			?>
		</div>

	</body>
</html>
