<?php
class Matrix {

	const IDENTITY = 1;
	const SCALE = 2;
	const RX = 3;
	const RY = 4;
	const RZ = 5;
	const TRANSLATION = 6;
	const PROJECTION = 7;

	public static $verbose = False;

	public static function doc() {
		echo file_get_contents("Matrix.doc.txt");
	}

	public function __construct(array $kwargs) {
		if ($kwargs['preset'] == self::IDENTITY)
			$this->matrixIdentity();
		else if ($kwargs['preset'] == self::SCALE && array_key_exists('scale', $kwargs))
			$this->matrixScale();
		else if (($kwargs['preset'] == self::RX || $kwargs['preset'] == self::RY || $kwargs['preset'] == self::RZ) && array_key_exists('angle', $kwargs))
			$this->matrixAngle();
		else if ($kwargs['preset'] == self::TRANSLATION && array_key_exists('vtc', $kwargs))
			$this->matrixTranslation();
		else if ($kwargs['preset'] == self::PROJECTION && array_key_exists('fov', $kwargs) && array_key_exists('ratio', $kwargs) && array_key_exists('near', $kwargs) && array_key_exists('far', $kwargs))
			$this->matrixProjection();
		else
			die("Error");

		if (self::$verbose)
			printf("test");
	}

	public function __destruct() {
		if (self::$verbose)
			echo "Matrix instance destructed";
	}

	public function __toString() {
		return sprintf("");
	}

	public function mult(Matrix $rhs) {
		$new_matrix = ;
		return $new_matrix;
	}

	public transformVertex(Vertex $vtx) {

	}
}
?>
