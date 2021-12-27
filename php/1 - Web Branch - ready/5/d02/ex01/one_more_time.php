#!/usr/bin/php
<?PHP

function month_to_int($str)
{
	$str = lcfirst($str);
	if ($str === "janvier")
		return 1;
	if ($str === "fevrier" || $str === "février")
		return 2;
	if ($str === "mars")
		return 3;
	if ($str === "avril")
		return 4;
	if ($str === "mai")
		return 5;
	if ($str === "juin")
		return 6;
	if ($str === "juillet")
		return 7;
	if ($str === "aout" || $str === "août")
		return 8;
	if ($str === "septembre")
		return 9;
	if ($str === "octobre")
		return 10;
	if ($str === "novembre")
		return 11;
	if ($str === "decembre" || $str === "décembre")
		return 12;
	echo "Wrong Format".PHP_EOL;
exit ;
}

if ($argc == 1)
	return ;
if (preg_match("/(^[A-Z]?)([a-z]+)( )([0-3]?)([0-9])( )([A-Z]?)([a-z]+)( )([0-9]{4})( )([0-2]?)([0-9])(:)([0-5])([0-9])(:)([0-5])([0-9]$)/", $argv[1]))
{
	$date = explode(" ", $argv[1]);
	$hours = explode(":", $date[4]);
	$date[2] = month_to_int($date[2]);
	date_default_timezone_set("Europe/Paris");
	print(mktime($hours[0], $hours[1], $hours[2], $date[2], $date[1], $date[3]));
}
else
	echo "Wrong Format";
echo PHP_EOL;
?>
