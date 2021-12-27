#!/usr/bin/php
<?php
  while (1)
  {
    echo "Enter a number: ";
    $stdin = fopen("php://stdin", "r");
    $line = trim(fgets($stdin));
    if (feof($stdin))
    {
      echo "\n";
      return ;
    }
    if (is_numeric($line))
    {
      if ($line % 2 == 0)
      	echo "The number ". $line ." is even";
      else
      	echo "The number ". $line ." is odd";
    }
    else
    	echo "'" .$line. "' is not a number";
    echo "\n";
    fclose($stdin);
  }
?>
