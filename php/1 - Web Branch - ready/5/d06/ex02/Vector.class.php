<?PHP

require_once "Color.class.php";
require_once "Vertex.class.php";

Class Vector {
	static public $verbose = false;
	private $_x = 0;
	private $_y = 0;
	private $_z = 0;
	private $_w = 0.00;

	public static function doc()
	{
		$str = file_get_contents("Vector.doc.txt");
		if ($str === FALSE)
			return "";
		return ($str);
	}

	function __construct(array $kwargs)
	{
		if (!array_key_exists("dest", $kwargs))
			exit("Cannot construct Vector : missing dest");
		if (array_key_exists("orig", $kwargs))
			$orig = $kwargs["orig"];
		else
			$orig = new Vertex(array("x" => 0, "y" => 0, "z" => 0));
		$this->_x = (double)($kwargs["dest"]->getX() - $orig->getX());
		$this->_y = (double)($kwargs["dest"]->getY() - $orig->getY());
		$this->_z = (double)($kwargs["dest"]->getZ() - $orig->getZ());
		if (self::$verbose === true)
			echo("$this constructed\n");
	}

	function getX(){return($this->_x);}
	function getY(){return($this->_y);}
	function getZ(){return($this->_z);}
	function getW(){return($this->_w);}

	private function square($nb)
	{
		return ($nb * $nb);
	}

	public function magnitude()
	{
		return (sqrt($this->square($this->_x) + $this->square($this->_y) + $this->square($this->_z)));
	}

	public function normalize()
	{
		if (($len = $this->magnitude()) == 1)
			return (new Vector(array("dest" => new Vertex(array("x" => $this->_x, "y" => $this->_y, "z" => $this->_z)))));
		return (new Vector(array("dest" => new Vertex(array("x" => $this->_x / $len, "y" => $this->_y / $len, "z" => $this->_z / $len)))));
	}

	public function add(Vector $rhs)
	{
		if ($rhs === NULL)
			return NULL;
		$addvertex = new Vertex(array("x" => $this->_x + $rhs->getX(), "y" => $this->_y + $rhs->getY(), "z" => $this->_z + $rhs->getZ()));
		return (new Vector(array("dest" => $addvertex)));
	}

	public function sub(Vector $rhs)
	{
		if ($rhs === NULL)
			return NULL;
		$subvertex = new Vertex(array("x" => $this->_x - $rhs->getX(), "y" => $this->_y - $rhs->getY(), "z" => $this->_z - $rhs->getZ()));
		return (new Vector(array("dest" => $subvertex)));
	}

	public function opposite()
	{
		$oppvertex = new Vertex(array("x" => -$this->_x, "y" => -$this->_y, "z" => -$this->_z));
		return (new Vector(array("dest" => $oppvertex)));
	}

	public function scalarProduct($k)
	{
		if ($k === NULL)
			return NULL;
		$scalprodvertex = new Vertex(array("x" => $this->_x * $k, "y" => $this->_y * $k, "z" => $this->_z * $k));
		return (new Vector(array("dest" => $scalprodvertex)));
	}

	public function dotProduct(Vector $rhs)
	{
		if ($rhs === NULL)
			return NULL;
		return ($this->_x * $rhs->getX() + $this->_y * $rhs->getY() + $this->_z * $rhs->getZ());
	}

	public function cos(Vector $rhs)
	{
		if ($rhs === NULL)
			return NULL;
		return ($this->dotProduct($rhs) / ($this->magnitude() * $rhs->magnitude()));
	}

	public function crossProduct(Vector $rhs)
	{
		if ($rhs === NULL)
			return NULL;
		$op_x = $this->_y * $rhs->getZ() - $this->_z * $rhs->getY();
		$op_y = $this->_z * $rhs->getX() - $this->_x * $rhs->getZ();
		$op_z = $this->_x * $rhs->getY() - $this->_y * $rhs->getX();
		return (new Vector(array("dest" => new Vertex(array("x" => $op_x, "y" => $op_y, "z" => $op_z)))));
	}

	public function __toString()
	{
		return (sprintf("Vector( x:%.2f, y:%.2f, z:%.2f, w:%.2f )", $this->_x, $this->_y, $this->_z, $this->_w));
	}

	function __destruct()
	{
		if (self::$verbose === true)
			echo("$this destructed\n");
	}
}
?>
