<?php
class Color {

	public $red;
	public $green;
	public $blue;

	public static $verbose = False;

	public static function doc() {
		if (file_exists("Color.doc.txt"))
			return file_get_contents("Color.doc.txt");
	}

	public function __construct(array $rgb) {

		if (array_key_exists('rgb', $rgb)) {
			$this->red = $rgb['rgb'] >> 16 & 0xFF;
			$this->green = $rgb['rgb'] >> 8 & 0xFF;
			$this->blue = $rgb['rgb'] & 0xFF;
		} else if (array_key_exists('red', $rgb) && array_key_exists('green', $rgb) && array_key_exists('blue', $rgb)) {
				$this->red = $rgb['red'];
				$this->green = $rgb['green'];
				$this->blue = $rgb['blue'];
		} else
			die("Error");

		if (self::$verbose)
			printf("Color( red: %3d, green: %3d, blue: %3d ) constructed.\n", $this->red, $this->green, $this->blue);
		return;
	}

	public function __destruct() {
		if (self::$verbose)
			printf("Color( red: %3d, green: %3d, blue: %3d ) destructed.\n", $this->red, $this->green, $this->blue);
		return;
	}

	public function __toString() {
		return sprintf("Color( red: %3d, green: %3d, blue: %3d )", $this->red, $this->green, $this->blue);
	}

	public function add($instance) {
		$red  = $this->red + $instance->red;
		$green  = $this->green + $instance->green;
		$blue  = $this->blue + $instance->blue;
		return (new Color(array("red" => $red, "green" => $green, "blue" => $blue)));
	}

	public function sub($instance) {
		$red  = $this->red - $instance->red;
		$green  = $this->green - $instance->green;
		$blue  = $this->blue - $instance->blue;
		return (new Color(array("red" => $red, "green" => $green, "blue" => $blue)));
	}

	public function mult($nb) {
		$red  = $this->red * $nb;
		$green  = $this->green * $nb;
		$blue  = $this->blue * $nb;
		return (new Color(array("red" => $red, "green" => $green, "blue" => $blue)));
	}
}
?>
