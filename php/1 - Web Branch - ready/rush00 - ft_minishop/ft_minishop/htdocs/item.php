<!doctype html>
<html>
	<head>
		<title>ft_minishop</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="/ft_minishop.css">
		<link rel="stylesheet" type="text/css" href="/item_css.css">
	</head>
	<body>
		<div class="main-box">
			<?php require($_SERVER['DOCUMENT_ROOT']."/header.php"); ?>
			<div class="content-box">
				<?php 
				require($_SERVER['DOCUMENT_ROOT']."/cart.php");
				if (!isset($_GET['id']))
					load_index_php();
				$request = "SELECT * FROM items WHERE id='".
					mysqli_real_escape_string($sql_ptr, $_GET['id'])."';";
				$result = mysqli_query($sql_ptr, $request);
				if (mysqli_num_rows($result) <= 0 ||
						!($row = mysqli_fetch_assoc($result)))
					load_index_php();
				$ipath;
				if (!isset($row['id']) ||
					!($ipath = "$imgs_path/".$row['id'].'.jpg') ||
					!file_exists($_SERVER['DOCUMENT_ROOT']."$ipath") ||
					($dat = getimagesize($_SERVER['DOCUMENT_ROOT'].$ipath)) === false ||
					$dat['mime'] !== 'image/jpeg')					
						$ipath = "$imgs_path/fallback.jpg";

				$request = "SELECT name FROM categories WHERE id='".
					mysqli_real_escape_string($sql_ptr, $row['category_id'])."';";
				$result = mysqli_query($sql_ptr, $request);
				$cat_name;
				if (mysqli_num_rows($result) > 0 &&
					$row2 = mysqli_fetch_assoc($result))
					$cat_name = $row2['name'];
				else
					$cat_name = "category";
				
				echo '<div class="back_category"><a href="/categories?cat='.
					$row['category_id'].
					'">Back to '.
					$cat_name.'</a></div>';
				echo "<img class=\"item_img\" src=\"$ipath\" />";
				echo '<div class="item_info">'.
					$row['name'].
					'<br/>'.
					money_format('%!10.2n &euro;', (float)$row['price'] / 100.).
					'<br/><div class="to_cart">';?>
				<!-- BUTTON ADD TO CART -->
					<form method="POST">
						<input type="hidden" name="submit_type" value="addtocart" />
							<div style="font-size: 15px;"><br/>Color :&nbsp;&nbsp;      
								<SELECT>
									<option value="black">Black</option>	
									<option value="red">Red</option>	
									<option value="pink">Pink</option>	
									<option value="green">Green</option>	
									<option value="blue">Blue</option>	
									<option value="white">White</option>	
								</SELECT><br/>
							</div>
						<input type="submit" value="Add to cart" />
					</form>
					<?php
						if (isset($_POST['submit_type']) && $_POST['submit_type'] == 'addtocart')
							add_to_cart($cart);
					?>
				<!--  -->
				</div></div>
			</div>
			<?php require($_SERVER['DOCUMENT_ROOT']."/footer.html"); ?>
		</div>
	</body>
</html>
