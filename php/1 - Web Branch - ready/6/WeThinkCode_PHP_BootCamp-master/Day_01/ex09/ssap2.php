#!/usr/bin/php
<?php
  if ($argc < 2)
  return ;

$aray = array();

$count = 0;
foreach ($argv as $elem_arg)
{
  if ($count == 0)
     $count = 1;
  else
  {
    if (!$test)
      $test = $elem_arg;
    else
      $test = "$test $elem_arg";
  }
}
$test = eregi_replace("[ ]+", " ", $test);
$aray = explode(" ", $test);


$alp = array();
$num = array();
$spec = array();

for ($i=0; $i < count($aray); $i++)
{
  if (ctype_alpha($aray[$i]))
    array_push($alp, $aray[$i]);
  elseif (ctype_digit($aray[$i]))
    array_push($num, $aray[$i]);
  else
    array_push($spec, $aray[$i]);
}
  usort($alp, "strnatcasecmp");
  sort($num, SORT_STRING);
	sort($spec, SORT_STRING);

  foreach ($alp as $elem_alp)
    echo $elem_alp . "\n";
    foreach ($num as $elem_num)
      echo $elem_num . "\n";
      foreach ($spec as $elem_spec)
        echo $elem_spec . "\n";
?>
