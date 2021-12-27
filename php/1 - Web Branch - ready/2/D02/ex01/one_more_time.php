#!/usr/bin/php
<?php
if ($argc != 2)
	exit();

$pattern = "/^((?:L|l)undi|(?:M|m)ardi|(?:M|m)ercredi|(?:J|j)eudi|(?:V|v)endredi|(?:S|s)amedi|(?:D|d)imanche) (\d{1,2}) ((?:J|j)anvier|(?:F|f)evrier|(?:M|m)ars|(?:A|a)vril|(?:M|m)ai|(?:J|j)uin|(?:J|j)uillet|(?:A|a)out|(?:S|s)eptember|(?:O|o)ctobre|(?:N|n)ovembre|(?:D|d)ecembre) (\d{4}) ([0-23]{2}):([0-59]{2}):([0-59]{2})/";
if (!preg_match($pattern, $argv[1], $time))
{
	echo "Wrong Format\n";
	exit();
}
$months = ["janvier", "fevrier", "mars", "avril", "mai", "juin", "juillet", "aout", "septembre", "octobre", "novembre", "decembre"];
$month = array_search(strtolower($time[3]), $months) + 1;
echo mktime($time[5], $time[6], $time[7], $month, $time[2], $time[4]);
?>
