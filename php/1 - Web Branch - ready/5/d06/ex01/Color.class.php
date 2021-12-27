<?PHP
Class Color {
	public static $verbose = false;
	public $red = 0;
	public $green = 0;
	public $blue = 0;

	public static function doc()
	{
		$str = file_get_contents("Color.doc.txt");
		if ($str === FALSE)
			return "";
		return ($str);
	}

	public function __construct(array $kwargs)
	{
		if (array_key_exists("rgb", $kwargs))
		{
			$this->red = (int)($kwargs["rgb"] / 256 / 256 % 256);
			$this->green = (int)($kwargs["rgb"] / 256 % 256);
			$this->blue = (int)($kwargs["rgb"] % 256);
		}
		if (array_key_exists("red", $kwargs))
			$this->red = (int)$kwargs["red"];
		if (array_key_exists("green", $kwargs))
			$this->green = (int)$kwargs["green"];
		if (array_key_exists("blue", $kwargs))
			$this->blue = (int)$kwargs["blue"];
		if (self::$verbose === true)
			echo ("$this constructed.\n");
	}

	public function add(Color $param)
	{
		if ($param == NULL)
			return NULL;
		return (new Color(array("red" => $this->red + $param->red, "green" => $this->green + $param->green, "blue" => $this->blue + $param->blue)));
	}

	public function sub(Color $param)
	{
		if ($param == NULL)
			return NULL;
		return (new Color(array("red" => $this->red - $param->red, "green" => $this->green - $param->green, "blue" => $this->blue - $param->blue)));
	}

	public function mult($param)
	{
		if ($param == NULL)
			return NULL;
		return (new Color(array("red" => $this->red * $param, "green" => $this->green * $param, "blue" => $this->blue * $param)));
	}

	public function __toString()
	{
		return (sprintf("Color( red: %3d, green: %3d, blue: %3d )", $this->red, $this->green, $this->blue));
	}

	public function __destruct()
	{
		if (self::$verbose === true)
			echo("$this destructed.\n");
	}
}
?>