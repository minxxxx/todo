Welcome <?php echo $_SESSION['login'];?><br/><br/>
<form method="POST">
	<input type="hidden" name="submit_type" value="logout" />
	<input type="submit" value="Logout" />
</form>
