#!/usr/bin/php
<?php
if (is_string($argv[1]) == false)
		return;

$split = ft_split($argv[1]);
$first = array_shift($split);
array_push($split, $first);

for ($i = 0; $i < count($split); $i++)
{
  echo $split[$i];
  if (is_string($split[$i + 1]))
    echo " ";
}
echo "\n";

function ft_split($str)
{
  $str = eregi_replace("[ ]+", " ", $str);
  $ret = explode(" ", $str);
  return ($ret);
}
?>
