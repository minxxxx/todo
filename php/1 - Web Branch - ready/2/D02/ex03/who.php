#!/usr/bin/php
<?php
    date_default_timezone_set('Europe/Paris');
    $file = fopen("/var/run/utmpx", 'r');
    $i = 0;
    $who = [];
    while ($str = fread($file, 628))
    {
        $tab = unpack("A256login/A4/A32tty/i/itype/Itime/i16", $str);
          if ($i >= 2 * 628 && $tab['type'] == 7)
          {
                $time = strftime("%b %e %R", $tab['time']);
                array_push($who , $tab['login']." ".$tab['tty']."  ".$time);
          }
        $i = $i + 628;
    }
    sort($who);
    foreach ($who as $value)
        echo "$value\n";
?>
