<?php
session_start();
include('config.php');

$error_msg = "";
if ($_SESSION['whoami'] != "")
	redirect('index.php');
if ($_POST['login'] != "" || $_POST['passwd'] != "") {
	if (auth($_POST['login'], $_POST['passwd'], $users_file)) {
		$_SESSION['whoami'] = $_POST['login'];
		if ($_SESSION['page'] && $_SESSION['page'] != "register.php")
			$url = $_SESSION['page'];
		else
			$url = "index.php";
		redirect($url);
	}
	else {
		$error_msg = "\n<font color=\"#ff666\">Authentification failed\n</font><br>";
	}
}
?>
<html>
<head>
	<title>42riders: Sign in</title>
	<link rel="stylesheet" type="text/css" href="css/login.css">
</head>
<body>
  <center>
  <form id="page-middle" action="login.php" method="post">
	<?php print $error_msg; ?>
      <table>
        <tr>
          <td>
            <input placeholder="Login" type="text" name="login" />
          </td>
          <tr>
            <td>
              <input placeholder="Password" type="password" name="passwd" />
            </td>
          </tr>
          <tr>
            <td id="connect-button">
              <input type="submit" name="submit" value="Connect" />
            </td>
          </tr>
	  </table>
    </form>
    <a href="register.php" title="Cr&eacute;er un compte">New? Create an account</a>
    <br />
    <a href="index.php" title="Retourner &agrave; l'accueil">Back</a>
    <br />
  </center>
</body>
</html>
