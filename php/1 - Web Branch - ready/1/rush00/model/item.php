<?php
function getItemCategories()
{
    $categories = queryDB('SELECT `id`, `name` FROM categories');
    return $categories;
}

function getItems()
{
    return queryDB('SELECT `items`.`id` AS `id`, `items`.`name` AS `name`, `items`.`price` AS `price`, `items`.`image_url` AS `image_url`, `items`.`description` AS `description`, `items`.`created_at` AS `created_at` 
                FROM `items`');
}

function getItemsFromCategory($category)
{
    return queryDB('SELECT `items`.`id` AS `id`, `items`.`name` AS `name`, `items`.`price` AS `price`, `items`.`image_url` AS `image_url`, `items`.`description` AS `description`, `items`.`created_at` AS `created_at` 
                FROM `items`
                INNER JOIN `items_categories` ON `items_categories`.`item_id` = `items`.`id`
                INNER JOIN `categories` ON `categories`.`id` = `items_categories`.`category_id`
                WHERE `categories`.`id` = ?', ['i', $category]);
}

function getMostPurchasedItems()
{
    return queryDB('SELECT `items`.`id` AS `id`, `items`.`name` AS `name`, `items`.`image_url` AS `image_url`, `items`.`price` AS `price`, `items`.`description` AS `description`, `items`.`created_at` AS `created_at` 
                    FROM `orders` 
                    INNER JOIN `items` ON `items`.`id` = `orders`.`item_id`
                    GROUP BY `orders`.`item_id`
                    ORDER BY COUNT(`orders`.`item_id`) DESC
                    LIMIT 10');
}

function addToCart($itemId)
{
    setQuantity($itemId);
}

function setQuantity($itemId, $quantity = 1)
{
    $quantity = intval($quantity);
    if ($quantity < 1) {
        unset($_SESSION['cart'][$itemId]);
        return;
    }
    if (!isset($_SESSION['cart']))
        $_SESSION['cart'] = [$itemId => $quantity];
    else
        $_SESSION['cart'][$itemId] = $quantity;
}

function getCart()
{
    if (!isset($_SESSION['cart']))
        return ['items' => [], 'total' => 0];
    $items = [];
    $total = 0;
    foreach ($_SESSION['cart'] as $itemId => $quantity) {
        if (!empty($item = queryDB('SELECT * FROM `items` WHERE `id` = ?', ['i', $itemId]))) {
            $items[] = array_merge($item[0], ['quantity' => $quantity]);
            $total += ($item[0]['price'] * $quantity);
        }
    }
    return [
        'items' => $items,
        'total' => $total
    ];
}

function isInCart($itemId)
{
    if (!isset($_SESSION['cart']))
        return false;
    return (isset($_SESSION['cart'][$itemId]));
}

function purchaseCart($items, $address)
{
    if (!getUser())
        return 'Vous devez ??tre connect?? pour proc??der ?? un achat !';
    foreach ($items as $item => $quantity)
        if (($error = purchaseItem($item, $quantity, $address)) !== true)
            return $error;
    return true;
}

function removeAccents($str) {
    $a = array('??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??');
    $b = array('A', 'A', 'A', 'A', 'A', 'A', 'AE', 'C', 'E', 'E', 'E', 'E', 'I', 'I', 'I', 'I', 'D', 'N', 'O', 'O', 'O', 'O', 'O', 'O', 'U', 'U', 'U', 'U', 'Y', 's', 'a', 'a', 'a', 'a', 'a', 'a', 'ae', 'c', 'e', 'e', 'e', 'e', 'i', 'i', 'i', 'i', 'n', 'o', 'o', 'o', 'o', 'o', 'o', 'u', 'u', 'u', 'u', 'y', 'y', 'A', 'a', 'A', 'a', 'A', 'a', 'C', 'c', 'C', 'c', 'C', 'c', 'C', 'c', 'D', 'd', 'D', 'd', 'E', 'e', 'E', 'e', 'E', 'e', 'E', 'e', 'E', 'e', 'G', 'g', 'G', 'g', 'G', 'g', 'G', 'g', 'H', 'h', 'H', 'h', 'I', 'i', 'I', 'i', 'I', 'i', 'I', 'i', 'I', 'i', 'IJ', 'ij', 'J', 'j', 'K', 'k', 'L', 'l', 'L', 'l', 'L', 'l', 'L', 'l', 'l', 'l', 'N', 'n', 'N', 'n', 'N', 'n', 'n', 'O', 'o', 'O', 'o', 'O', 'o', 'OE', 'oe', 'R', 'r', 'R', 'r', 'R', 'r', 'S', 's', 'S', 's', 'S', 's', 'S', 's', 'T', 't', 'T', 't', 'T', 't', 'U', 'u', 'U', 'u', 'U', 'u', 'U', 'u', 'U', 'u', 'U', 'u', 'W', 'w', 'Y', 'y', 'Y', 'Z', 'z', 'Z', 'z', 'Z', 'z', 's', 'f', 'O', 'o', 'U', 'u', 'A', 'a', 'I', 'i', 'O', 'o', 'U', 'u', 'U', 'u', 'U', 'u', 'U', 'u', 'U', 'u', 'A', 'a', 'AE', 'ae', 'O', 'o', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??');
    return str_replace($a, $b, $str);
}

function purchaseItem($itemId, $quantity = 1, $address)
{
    if (!preg_match('/^\d+ [a-zA-Z\' ]+, \d+ [a-zA-Z ]+, [a-zA-Z ]+$/', $address))
        return "L'adresse est invalide";
    if (empty(queryDB('SELECT `id` FROM `items` WHERE `id` = ?', ['i', $itemId])))
        return true;
    queryDB('INSERT INTO `orders` SET `item_id` = ?, `quantity` = ?, `user_id` = ?, `address` = ?, `created_at` = ?', [
       'iiiss', $itemId, $quantity, getUser()['id'], $address, date('Y-m-d H:i:s')
    ]);
    return true;
}