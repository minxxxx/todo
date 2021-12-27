<?php

require_once 'Vertex.class.php';

class Vector {

	private $_x;
	private $_y;
	private $_z;
	private $_w;

	public static $verbose = False;

	public function getX() { return $this->_x; }
	public function getY() { return $this->_y; }
	public function getZ() { return $this->_z; }
	public function getW() { return $this->_w; }

	public static function doc() {
		if (file_exists("Vector.doc.txt"))
			return file_get_contents("Vector.doc.txt");
	}

	public function __construct(array $kwargs) {
		if (!array_key_exists('dest', $kwargs))
			die("Error");
		if (array_key_exists('orig', $kwargs))
			$orig = clone $kwargs['orig'];
		else
			$orig = new Vertex(array('x' => 0, 'y' => 0, 'z' => 0));
		$dest = clone $kwargs['dest'];
		$this->_x = $dest->getX() - $orig->getX();
		$this->_y = $dest->getY() - $orig->getY();
		$this->_z = $dest->getZ() - $orig->getZ();
		$this->_w = 0.0;

		if (self::$verbose)
			printf("Vector( x:%.2f, y:%.2f, z:%.2f, w:%.2f ) constructed\n", $this->_x, $this->_y, $this->_z, $this->_w);
	}
	public function __destruct() {
		if (self::$verbose)
			printf("Vector( x:%.2f, y:%.2f, z:%.2f, w:%.2f ) destructed\n", $this->_x, $this->_y, $this->_z, $this->_w);
	}

	public function __toString() {
		return sprintf("Vector( x:%.2f, y:%.2f, z:%.2f, w:%.2f )", $this->_x, $this->_y, $this->_z, $this->_w);
	}

	public function magnitude() {
		return (sqrt($this->_x * $this->_x + $this->_y * $this->_y + $this->_z * $this->_z));
	}

	public function normalize() {
		if ($this->magnitude() == 1)
			return (clone $this);
		$new_x = $this->_x / $this->magnitude();
		$new_y = $this->_y / $this->magnitude();
		$new_z = $this->_z / $this->magnitude();
		return (new Vector(array('dest' => new Vertex(array('x' => $new_x, 'y' => $new_y, 'z' => $new_z)))));
	}

	public function add(Vector $rhs) {
		$new_x = $this->_x + $rhs->getX();
		$new_y = $this->_y + $rhs->getY();
		$new_z = $this->_z + $rhs->getZ();
		return (new Vector(array('dest' => new Vertex(array('x' => $new_x, 'y' => $new_y, 'z' => $new_z)))));
	}

	public function sub(Vector $rhs) {
		$new_x = $this->_x - $rhs->getX();
		$new_y = $this->_y - $rhs->getY();
		$new_z = $this->_z - $rhs->getZ();
		return (new Vector(array('dest' => new Vertex(array('x' => $new_x, 'y' => $new_y, 'z' => $new_z)))));
	}

	public function opposite() {
		return new Vector(array('dest' => new Vertex(array('x' => -$this->_x, 'y' => -$this->_y, 'z' => -$this->_z))));
	}

	public function scalarProduct($k) {
		return (new Vector(array('dest' => new Vertex(array('x' => $this->_x * $k, 'y' => $this->_y * $k, 'z' => $this->_z * $k)))));
	}

	public function dotProduct($rhs) {
		return $this->_x * $rhs->getX() + $this->_y * $rhs->getY() + $this->_z * $rhs->getZ();
	}

	public function cos($rhs) {
		return ($this->dotProduct($rhs) / ($this->magnitude() * $rhs->magnitude()));
	}

	public function crossProduct($rhs) {
		$crossed = array(
			'x' => $this->getY() * $rhs->getZ() - $this->getZ() * $rhs->getY(),
			'y' => $this->getZ() * $rhs->getX() - $this->getX() * $rhs->getZ(),
			'z' => $this->getX() * $rhs->getY() - $this->getY() * $rhs->getX()
		);
		return (new Vector(array('dest' => new Vertex($crossed))));
	}
}
?>
