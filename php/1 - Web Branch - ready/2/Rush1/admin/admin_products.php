<?php
$product_added = 0;

function generate_random_id()
{
	$i = 0;
	$res = "";

	while ($i < 12)
	{
		if ($i % 2 == 0)
			$char = chr(rand(97, 122));
		else
			$char = rand(0, 9);
		$res = $res.$char;
		$i++;
	}
	return $res;
}

if ($_POST['submit'] == 'OK')
{
	$error = 0;

	if (isset($_POST['name']) && $_POST['name'] !== '' && isset($_POST['description']) && $_POST['description'] !== ''  && isset($_POST['quantity']) && $_POST['quantity'] !== ''  && isset($_POST['price'])  && $_POST['price'] !== '' && isset($_POST['category'])  && $_POST['category'] !== '')
	{
		if (!preg_match("/^[0-9]{1,10}$/", $_POST['quantity']) || intval($_POST['quantity']) < 0)
			$error = 1;
		if (!preg_match("/^[0-9]{1,10}$/", $_POST['price']) || intval($_POST['price']) < 0)
			$error = 1;
		if (!preg_match("/^[A-Za-z0-9 -]+$/", $_POST['name']))
			$error = 1;

		if (is_uploaded_file($_FILES["photo"]["tmp_name"]) && $error == 0)
		{
			if (!file_exists($upload_dir))
				mkdir($upload_dir);
			$ext = pathinfo($_FILES['photo']['name']);
			$ext = $ext['extension'];
			$name = preg_replace("/\s+/", "", trim($_POST['name']));
			$photo = $upload_dir.$name.date("YmdHis").".".$ext;

			if (!move_uploaded_file($_FILES["photo"]["tmp_name"], $photo))
				$photo = '';
		}
		else
			$error = 1;

		if (!$error)
		{
			$new_product = array(
				"id" => generate_random_id(),
				"name" => $_POST['name'],
				"photo" => $photo,
				"description" => $_POST['description'],
				"quantity" => intval($_POST['quantity']),
				"price" => $_POST['price'],
				"category" => $_POST['category']
			);

			$products = get_content($products_file, FALSE);
			$products[] = $new_product;
			file_put_contents($products_file, serialize($products));
			$product_added = 1;
		}
	}
	else if (isset($_POST['category']) && $_POST['category'] !== '' )
	{
		$cat_already_exists = 0;
		if ($categories = get_content('./private/categories', FALSE)) {
			foreach($categories as $category) {
				if ($category == $_POST['category']) {
					$cat_already_exists = 1;
					break;
				}
			}
			if (!$cat_already_exists) {
				$categories[] = $_POST['category'];
				file_put_contents('./private/categories', serialize($categories));
			}
		}
	}
	else
		$error = 1;
} else if ($_POST['submit'] == 'Change') {
	if (isset($_POST['newname']) && $_POST['newname'] !== '' && isset($_POST['newdesc']) && $_POST['newdesc'] !== ''  && isset($_POST['newqty']) && $_POST['newqty'] !== ''  && isset($_POST['newprice'])  && $_POST['newprice'] !== '' && isset($_POST['newcat'])  && $_POST['newcat'] !== '' && isset($_POST['prodId']) && $_POST['prodId'] != '')
	{
		$error_change = 0;

		if (!preg_match("/^[0-9]{1,10}$/", $_POST['newqty']) || intval($_POST['newqty']) < 0)
			$error_change = 1;
		if (!preg_match("/^[0-9]{1,10}$/", $_POST['newprice']) || intval($_POST['newprice']) < 0)
			$error_change = 1;
		if (!preg_match("/^[A-Za-z0-9 -]+$/", $_POST['newname']))
			$error_change = 1;

		if (!$error_change)
		{
			if ($products = get_content($products_file, FALSE)) {
				foreach($products as $i => $product) {
					if ($product['id'] == $_POST['prodId']) {
						$products[$i]["name"] = $_POST['newname'];
						$products[$i]["description"] = $_POST['newdesc'];
						$products[$i]["quantity"] = intval($_POST['newqty']);
						$products[$i]["price"] = $_POST['newprice'];
						$products[$i]["category"] = $_POST['newcat'];
						break;
					}
				}
			}
			file_put_contents($products_file, serialize($products));
		}
	}
}

?>

<table id="add">
	<tr>
		<td>
			<?php
			if ($product_added) echo "<p style='color:red;'>Product successfully added !</p>";
			if ($error) echo "<p style='color:red;'>Error !</p>";
			?>
			<h2>Add new product</h2>
			<form enctype="multipart/form-data" action="admin.php?page=products" method="post">
				<input type="text" name="name" placeholder="Product name" /><br />
				<input type="file" name="photo" /><br />
				<textarea name="description" rows="4" cols="40" placeholder="Product description"></textarea><br />
				<input type="text" name="quantity" placeholder="Product quantity" /><br />
				<input type="text" name="price" placeholder="Product price" /><br />
				<select name="category">
					<?php
						if ($categories = get_content('./private/categories', FALSE)) {
							foreach($categories as $category) {
								echo "<option value='{$category}'>{$category}</option>";
							}
						}
					?>
				</select>
				<input type="submit" name="submit" value="OK" />
			</form>
		</td>
		<td>
			<h2>Add category</h2>
			<form enctype="multipart/form-data" action="admin.php?page=products" method="post">
				<input type="text" name="category" placeholder="New category" /><br />
				<input type="submit" name="submit" value="OK" />
			</form>
		</td>
	</tr>
</table>

<table id="products">
	<thead>
		<th>Name</th>
		<th>Category</th>
		<th>Photo</th>
		<th>Description</th>
		<th>Price</th>
		<th>Quantity</th>
		<th>Change</th>
	</thead>
	<tbody>
		<?php
			if ($all_products = get_content($products_file, TRUE)) {
				foreach($all_products as $product) {
					echo "<tr>\n";
					echo "<form action='admin.php?page=products' method='post'><input type='hidden' name='prodId' value='{$product['id']}' />";
					echo "<td><input type='text' name='newname' value='". $product['name'] ."' /></td>\n";
					echo "<td><select name='newcat'>";
					if ($categories = get_content('./private/categories', FALSE)) {
						foreach($categories as $category) {
							if ($product['category'] == $category)
								echo "<option value='{$category}' selected>{$category}</option>";
							else
								echo "<option value='{$category}'>{$category}</option>";
						}
					}
					echo "</select></td>";
					echo "<td><a href='". $product['photo'] ."'><img src='". $product['photo'] ."' /></a></td>\n";
					echo "<td class='prod_desc'><textarea name='newdesc'>". $product['description'] ."</textarea></td>\n";
					echo "<td><input type='text' name='newprice' value='". $product['price'] ."' /></td>\n";
					echo "<td><input type='text' name='newqty' value='". $product['quantity'] ."' /></td>\n";
					echo "<td><input type='submit' name='submit' value='Change' /></td>";
					echo "</form>";
					echo "</tr>\n";
				}
			}
		?>
	</tbody>
</table>
