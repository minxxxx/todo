#!/usr/bin/php
<?php
  if ($argc < 2)
  return ;
  $count = 0;
  foreach ($argv as $elem_arg)
  {
  	if ($count == 0)
  	   $count = 1;
  	else
    {
      if (!$str)
        $str = $elem_arg;
      else
        $str = "$str $elem_arg";
    }
  }
	$str = eregi_replace("[ ]+", " ", $str);
	$ret = explode(" ", $str);
	sort($ret, SORT_STRING);
  foreach ($ret as $elem_arg)
  {
    echo $elem_arg . "\n";
  }

?>
