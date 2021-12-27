<?php

class NightsWatch {

	private $_recruits;

	public function __construct() {
		$this->_recruits = array();
	}

	public function recruit($person) {
		if (is_a($person, "IFighter"))
			array_push($this->_recruits, $person);

	}

	public function fight() {
		foreach($this->_recruits as $rec) {
			$rec->fight();
		}
	}
}

?>
