<?php
class NightsWatch implements IFighter
{
	private $_recruited = array();
	public function recruit($person)
	{
		$this->_recruited[] = $person;
	}
	public function fight()
	{
		foreach ($this->_recruited as $p)
			if ($p instanceof IFighter)
				$p->fight();
	}
}
?>
