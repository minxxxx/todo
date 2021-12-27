#!/usr/bin/php
<?php

if ($argc < 2)
  return ;
$str = trim($argv[1]);
$str = eregi_replace("[ ]+", " ", $str);
echo $str . "\n";

?>
