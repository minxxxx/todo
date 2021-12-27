<?php

abstract class Fighter {

	private $_type;

	abstract function fight($arg);

	public function __construct($str) {
		$this->_type = $str;
	}

	public function getType() {
		return $this->_type;
	}
}

?>
