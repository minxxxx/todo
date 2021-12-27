<?PHP

class Jaime {
	function sleepWith($param)
	{
		$name = get_class($param);
		$parent = get_parent_class($param);
		if ($name === "Tyrion")
			echo ("Not even if I'm drunk !\n");
		else if ($name === "Sansa" || $parent === "Stark")
			echo ("Let's do this.\n");
		else if ($name === "Cersei" || $parent === "Lannister")
			echo ("With pleasure, but only in a tower in Winterfell, then.\n");
	}
}

?>