#!/usr/bin/php
<?PHP

function get_operation($str)
{
	if (strpos($str, "%") != false)
		return ("%");
	else if (strpos($str, "*") != false)
		return ("*");
	else if (strpos($str, "/") != false)
		return ("/");
	else if (strpos($str, "+") != false)
		return ("+");
	else if (strpos($str, "-") != false)
		return ("-");
	else
		return (false);
}

if ($argc != 2)
{
	echo "Incorrect Parameters\n";
	return ;
}
else
{
  $get_op = get_operation($argv[1]);
  $array = explode($get_op, $argv[1]);
  if ($get_op != false)
{
  if (count($array) == 2)
  {
    if (!is_numeric(trim($array[0])))
      echo "Syntax Error\n";
    else if (!is_numeric(trim($array[1])))
      echo "Syntax Error\n";
    else
    {
      if (strcmp($get_op, "+") == 0)
        print "$array[0]" + "$array[1]". "\n";
      if (strcmp($get_op, "-") == 0)
        print "$array[0]" - "$array[1]". "\n";
      if (strcmp($get_op, "%") == 0)
        print "$array[0]" % "$array[1]". "\n";
      if (strcmp($get_op, "*") == 0)
        print "$array[0]" * "$array[1]". "\n";
      if (strcmp($get_op, "/") == 0)
        print "$array[0]" / "$array[1]". "\n";
    }
  }
  else if (count($array) != 2)
    echo "Incorrect Parameters\n";
  else
    echo "Syntax Error\n";
}
else
  echo "Syntax Error\n";
}

?>
