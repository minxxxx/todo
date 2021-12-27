#!/usr/bin/php
<?php

$count = 0;
foreach ($argv as $elem_arg)
{
	if ($count == 0)
	   $count = 1;
	else
		echo $elem_arg."\n";
}

?>
