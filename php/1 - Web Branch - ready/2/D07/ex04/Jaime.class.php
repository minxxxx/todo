<?php

class Jaime extends Lannister {
	public function sleepWith($person) {
		if (is_a($person, "Cersei"))
			echo "With pleasure, but only in a tower in Winterfell, then.\n";
		else
			parent::sleepWith($person);
	}
}

?>
