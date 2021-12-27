#!/usr/bin/php
<?php
date_default_timezone_set('CET');
$fd = fopen("/var/run/utmpx", "r");
while ($octs = fread($fd, 628))
{
   $unpacked = unpack("a256user/a4id/a32line/ipid/itype/I2time/a256host/i16pad", $octs);
   if ($unpacked["type"] == 7)
      $user[$unpacked["line"]] = array("user" => $unpacked["user"], "time" => $unpacked["time1"]);
}
ksort($user);
foreach($user as $line => $data){
  $test = sprintf("%-7s   %-7s  %s\n", $data["user"], $line,date("M  j H:i", $data["time"]));
  $test = preg_filter ("/[^[:print:]]/", "", $test);
  echo $test." \n";
}
?>
