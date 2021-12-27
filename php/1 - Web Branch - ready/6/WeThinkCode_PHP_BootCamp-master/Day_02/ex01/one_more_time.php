#!/usr/bin/php
<?PHP
function wrong_format()
{
    echo "Wrong Format\n";
    exit(1);
}
if ($argc != 2)
{
    exit(1);
}
$filter = explode(" ", $argv[1]);
$filter = array_filter($filter);
$filter = array_slice($filter, 0);
if (count($filter) != 5)
    wrong_format();
$imploded = implode(" ", $filter);
if (preg_match("/[0-9][0-9]:[0-9][0-9]:[0-9][0-9]/", $imploded) != 1)
    wrong_format();
$before = $imploded;
$imploded = preg_replace("/[Jj]anvier/", '01', $imploded);
$imploded = preg_replace('/[Ff]evrier/', '02', $imploded);
$imploded = preg_replace('/[Mm]ars/', '02', $imploded);
$imploded = preg_replace('/[Aa]vril/', '03', $imploded);
$imploded = preg_replace('/[Mm]ai/', '05', $imploded);
$imploded = preg_replace('/[Jj]uin/', '06', $imploded);
$imploded = preg_replace('/[Jj]uillet/', '07', $imploded);
$imploded = preg_replace('/[Aa]out/', '08', $imploded);
$imploded = preg_replace('/[Ss]eptembre/', '09', $imploded);
$imploded = preg_replace('/[Oo]ctobre/', '10', $imploded);
$imploded = preg_replace('/[Nn]ovembre/', '11', $imploded);
$imploded = preg_replace('/[Dd]ecembre/', '12', $imploded);
if ($before === $imploded)
    wrong_format();
$before = $imploded;
$imploded = preg_replace('/[Dd]imanche/', '0', $imploded);
$imploded = preg_replace('/[Ll]undi/', '1', $imploded);
$imploded = preg_replace('/[Mm]ardi/', '2', $imploded);
$imploded = preg_replace('/[Mm]ercredi/', '3', $imploded);
$imploded = preg_replace('/[Jj]eudi/', '4', $imploded);
$imploded = preg_replace('/[Vv]endredi/', '5', $imploded);
$imploded = preg_replace('/[Ss]amedi/', '6', $imploded);
if ($before === $imploded)
    wrong_format();
$trying_to_parse = strptime($imploded, "%w %d %m %Y %H:%M:%S");
if ($trying_to_parse === FALSE)
    wrong_format();
if (strlen($trying_to_parse["unparsed"]) > 0)
    wrong_format();
unset($filter[0]);
$s_original = implode(" ", $filter);
$s_original = preg_replace("/[Jj]anvier/", 'January', $s_original);
$s_original = preg_replace('/[Ff]evrier/', 'February', $s_original);
$s_original = preg_replace('/[Mm]ars/', 'March', $s_original);
$s_original = preg_replace('/[Aa]vril/', 'April', $s_original);
$s_original = preg_replace('/[Mm]ai/', 'May', $s_original);
$s_original = preg_replace('/[Jj]uin/', 'June', $s_original);
$s_original = preg_replace('/[Jj]uillet/', 'July', $s_original);
$s_original = preg_replace('/[Aa]out/', 'August', $s_original);
$s_original = preg_replace('/[Ss]eptembre/', 'September', $s_original);
$s_original = preg_replace('/[Oo]ctobre/', 'October', $s_original);
$s_original = preg_replace('/[Nn]ovembre/', 'November', $s_original);
$s_original = preg_replace('/[Dd]ecembre/', 'December', $s_original);
date_default_timezone_set("Europe/Paris");
$time_string = strtotime($s_original);
if (strlen($time_string) > 0)
   echo strtotime($s_original) . "\n";
else
	wrong_format();
?>
