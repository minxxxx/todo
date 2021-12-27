<br/><h2>MY COMMANDS:</h2>
<?php
$ret = mysqli_query($sql_ptr, "SELECT c.id, c.amount, c.date ".
	"FROM commands c LEFT JOIN users u on c.user_id=u.id ".
	"WHERE u.login='".
	mysqli_real_escape_string($sql_ptr, $_SESSION['login'])."';");
while ($tab = mysqli_fetch_assoc($ret))
    echo '&nbsp;&nbsp;&#9679; Command #'.
		$tab['id'].'&nbsp;:&nbsp;'.
		money_format('%!10.2n &euro;', (float)$tab['amount'] / 100.).
		'&nbsp;('.$tab['date'].')<br/>';
?>
