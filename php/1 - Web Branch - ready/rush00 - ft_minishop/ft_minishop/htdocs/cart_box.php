<h2>CART:</h2>
<?php print_cart($sql_ptr); if (!empty($_SESSION['cart'])){?>
<form method="POST">
	<input type="hidden" name="submit_type" value="clrcart" />
	<input type="submit" value="Clear cart" />
</form>
<?php if (!empty($_SESSION['login'])){ ?>
	<form method="POST">
		<input type="hidden" name="submit_type" value="checkout" />
		<input type="submit" value="Checkout" />
	</form>
<?php }} ?>
