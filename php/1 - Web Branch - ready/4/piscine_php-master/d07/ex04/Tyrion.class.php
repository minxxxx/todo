<?php
class Tyrion
{
	public function sleepWith($p)
	{
		if ($p instanceof Jaime)
			print("Not even if I'm drunk !".PHP_EOL);
		else if ($p instanceof Sansa)
			print("Let's do this.".PHP_EOL);
		else if ($p instanceof Cersei)
			print("Not even if I'm drunk !".PHP_EOL);
	}
}
?>
