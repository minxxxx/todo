<?php

class UnholyFactory {

	private $_absorbed;

	public function __construct() {
		$this->_absorbed = array();
	}

	public function absorb($person) {
		if (is_a($person, "Fighter")) {
			if (array_key_exists($person->getType(), $this->_absorbed)) {
				printf("(Factory already absorbed a fighter of type %s)\n", $person->getType());
			} else {
				printf("(Factory absorbed a fighter of type %s)\n", $person->getType());
				$this->_absorbed[$person->getType()] = $person;
			}
		}
		else
			printf("(Factory can't absorb this, it's not a fighter)\n");
	}

	public function fabricate($type) {
		if (array_key_exists($type, $this->_absorbed)) {
			printf("(Factory fabricates a fighter of type %s)\n", $type);
			return $this->_absorbed[$type];
		}
		else {
			printf("(Factory hasn't absorbed any fighter of type %s)\n", $type);
			return null;
		}
	}
}

?>
