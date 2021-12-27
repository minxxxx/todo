#!/usr/bin/php
<?php
if ($argc < 2)
exit();
else
{
  echo  preg_replace('/\s+/', ' ', trim($argv[1])) ."\n";
}
 ?>
