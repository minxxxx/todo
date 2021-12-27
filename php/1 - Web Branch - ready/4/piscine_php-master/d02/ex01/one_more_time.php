#!/usr/bin/php
<?php
if ($argc == 2)
{
	$date = explode(" ", $argv[1]);
	$time = explode(":", $date[4]);
	if (strcasecmp("Lundi", $date[0]) != 0
	&& strcasecmp("Mardi", $date[0]) != 0
	&& strcasecmp("Mercredi", $date[0]) != 0
	&& strcasecmp("Jeudi", $date[0]) != 0
	&& strcasecmp("Vendredi", $date[0]) != 0
	&& strcasecmp("Samedi", $date[0]) != 0
	&& strcasecmp("Dimanche", $date[0]) != 0)
	{
		echo "Wrong Format\n";
		exit;
	}
	$date[1] = intval($date[1]);
	if ($date[1] < 1 || $date[1] > 31)
	{
		echo "Wrong Format\n";
		exit;
	}
	if (strcasecmp("Janvier", $date[2]) != 0
	&& strcasecmp("Fevrier", $date[2]) != 0
	&& strcasecmp("Mars", $date[2]) != 0
	&& strcasecmp("Avril", $date[2]) != 0
	&& strcasecmp("Mai", $date[2]) != 0
	&& strcasecmp("Juin", $date[2]) != 0
	&& strcasecmp("Juillet", $date[2]) != 0
	&& strcasecmp("Aout", $date[2]) != 0
	&& strcasecmp("Septembre", $date[2]) != 0
	&& strcasecmp("Octobre", $date[2]) != 0
	&& strcasecmp("Novembre", $date[2]) != 0
	&& strcasecmp("Decembre", $date[2]) != 0)
	{
		echo "Wrong Format\n";
		exit;
	}
	$date[3] = intval($date[3]);
	if ($date[3] < 1970)
	{
		echo "Wrong Format\n";
		exit;
	}
	$time[0] = intval($time[0]);
	if ($time[0] < 0 || $time[0] > 24)
	{
		echo "Wrong Format\n";
		exit;
	}
	$time[1] = intval($time[1]);
	if ($time[1] < 0 || $time[1] > 59)
	{
		echo "Wrong Format\n";
		exit;
	}
	$time[2] = intval($time[2]);
	if ($time[2] < 0 || $time[2] > 59)
	{
		echo "Wrong Format\n";
		exit;
	}
	$hour = $time[0];
	$minute = $time[1];
	$second = $time[2];
	if (strcasecmp("Janvier", $date[2]) == 0)
		$month = 1;
	else if (strcasecmp("Fevrier", $date[2]) == 0)
		$month = 2;
	else if (strcasecmp("Mars", $date[2]) == 0)
		$month = 3;
	else if (strcasecmp("Avril", $date[2]) == 0)
		$month = 4;
	else if (strcasecmp("Mai", $date[2]) == 0)
		$month = 5;
	else if (strcasecmp("Juin", $date[2]) == 0)
		$month = 6;
	else if (strcasecmp("Juillet", $date[2]) == 0)
		$month = 7;
	else if (strcasecmp("Aout", $date[2]) == 0)
		$month = 8;
	else if (strcasecmp("Septembre", $date[2]) == 0)
		$month = 9;
	else if (strcasecmp("Octobre", $date[2]) == 0)
		$month = 10;
	else if (strcasecmp("Novembre", $date[2]) == 0)
		$month = 11;
	else if (strcasecmp("Decembre", $date[2]) == 0)
		$month = 12;
	else
	{
		echo "Wrong Format\n";
		exit;
	}
	$day = $date[1];
	$year = $date[3];
	date_default_timezone_set('UTC');
	$result = mktime($hour, $minute, $second, $month, $day, $year, 1);
	$weekday = date('l', $result);
	if ($weekday == "Monday" && strcasecmp("Lundi", $date[0]) == 0)
		echo $result."\n";
	else if ($weekday == "Tuesday" && strcasecmp("Mardi", $date[0]) == 0)
		echo $result."\n";
	else if ($weekday == "Wednesday" && strcasecmp("Mercredi", $date[0]) == 0)
		echo $result."\n";
	else if ($weekday == "Thursday" && strcasecmp("Jeudi", $date[0]) == 0)
		echo $result."\n";
	else if ($weekday == "Friday" && strcasecmp("Vendredi", $date[0]) == 0)
		echo $result."\n";
	else if ($weekday == "Saturday" && strcasecmp("Samedi", $date[0]) == 0)
		echo $result."\n";
	else if ($weekday == "Sunday" && strcasecmp("Dimanche", $date[0]) == 0)
		echo $result."\n";
	else
		echo "Wrong Format\n";
}
?>
