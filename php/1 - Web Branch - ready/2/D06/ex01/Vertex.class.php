<?php

require_once 'Color.class.php';

class Vertex {

	private $_x;
	private $_y;
	private $_z;
	private $_w;
	private $_color;

	public static $verbose = False;

	public function getX() { return $this->_x; }
	public function getY() { return $this->_y; }
	public function getZ() { return $this->_z; }
	public function getW() { return $this->_w; }
	public function getColor() { return $this->_color; }
	public function setX($val) { $this->_x = $val; }
	public function setY($val) { $this->_y = $val; }
	public function setZ($val) { $this->_z = $val; }
	public function setW($val) { $this->_w = $val; }
	public function setColor($val) { $this->_color = clone $val; }

	public static function doc() {
		if (file_exists("Vertex.doc.txt"))
			return file_get_contents("Vertex.doc.txt");
	}

	public function __construct(array $kwargs) {
		if (!(array_key_exists('x', $kwargs) && array_key_exists('y', $kwargs) && array_key_exists('z', $kwargs)))
			die("Error Vertex");
		$this->_x = $kwargs['x'];
		$this->_y = $kwargs['y'];
		$this->_z = $kwargs['z'];

		if (array_key_exists('w', $kwargs))
			$this->_w = $kwargs['w'];
		else
			$this->_w = 1.0;

		if (array_key_exists('color', $kwargs))
			$this->_color = clone $kwargs['color'];
		else
			$this->_color = new Color(array("red" => 255, "green" => 255, "blue" => 255));

		if (self::$verbose)
			printf("Vertex( x: %.2f, y: %.2f, z:%.2f, w:%.2f, %s ) constructed\n", $this->_x, $this->_y, $this->_z, $this->_w, $this->_color);
	}

	public function __destruct() {
		if (self::$verbose)
			printf("Vertex( x: %.2f, y: %.2f, z:%.2f, w:%.2f, %s ) destructed\n", $this->_x, $this->_y, $this->_z, $this->_w, $this->_color);
		return;
	}

	public function __toString() {
		if (self::$verbose)
			return sprintf("Vertex( x: %.2f, y: %.2f, z:%.2f, w:%.2f, %s )", $this->_x, $this->_y, $this->_z, $this->_w, $this->_color);
		else
			return sprintf("Vertex( x: %.2f, y: %.2f, z:%.2f, w:%.2f )", $this->_x, $this->_y, $this->_z, $this->_w);
	}
}
?>
