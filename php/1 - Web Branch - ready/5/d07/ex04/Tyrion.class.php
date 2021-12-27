<?PHP

class Tyrion {
	function sleepWith($param)
	{
		$name = get_class($param);
		$parent = get_parent_class($param);
		if ($name === "Jaime" || $name === "Cersei" || $parent === "Lannister")
			echo ("Not even if I'm drunk !\n");
		else if ($name === "Sansa" || $parent === "Stark")
			echo ("Let's do this.\n");
	}
}

?>