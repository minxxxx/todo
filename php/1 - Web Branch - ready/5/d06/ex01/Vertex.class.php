<?PHP

require_once "Color.class.php";

Class Vertex {
	static public $verbose = false;
	private $_x;
	private $_y;
	private $_z;
	private $_w = 1.0;
	private $_color;

	public static function doc()
	{
		$str = file_get_contents("Vertex.doc.txt");
		if ($str === false)
			return "";
		return ($str);
	}

	function __construct(array $kwargs)
	{
		if (!array_key_exists('x', $kwargs))
			exit("Cannot construct Vertex : missing X.");
		$this->_x = (double)$kwargs["x"];
		if (!array_key_exists('y', $kwargs))
			exit("Cannot construct Vertex : missing Y.");
		$this->_y = (double)$kwargs["y"];
		if (!array_key_exists('z', $kwargs))
			exit("Cannot construct Vertex : missing Z.");
		$this->_z = (double)$kwargs["z"];
		if (array_key_exists("w", $kwargs))
			$this->_w = $kwargs["w"];
		if (array_key_exists("color", $kwargs))
			$this->_color = $kwargs["color"];
		else
			$this->_color = new Color(array("rgb" => 16777215));;
		if (self::$verbose === true)
		echo("$this constructed\n");
	}

	function getX(){return($this->_x);}
	function getY(){return($this->_y);}
	function getZ(){return($this->_z);}
	function getW(){return($this->_w);}
	function getColor(){return($this->_color);}

	function setX($param){$this->_x = $param;}
	function setY($param){$this->_y = $param;}
	function setZ($param){$this->_z = $param;}
	function setW($param){$this->_w = $param;}
	function setColor(Color $param){$this->_color = $param;}

	public function __toString()
	{
		if (self::$verbose === true)
			return (sprintf("Vertex( x: %.2f, y: %.2f, z:%.2f, w:%.2f, %s )", $this->_x, $this->_y, $this->_z, $this->_w, $this->_color));
		return (sprintf("Vertex( x: %.2f, y: %.2f, z:%.2f, w:%.2f )", $this->_x, $this->_y, $this->_z, $this->_w));
	}

	function __destruct()
	{
		if (self::$verbose === true)
			echo("$this destructed\n");
	}
}
?>
