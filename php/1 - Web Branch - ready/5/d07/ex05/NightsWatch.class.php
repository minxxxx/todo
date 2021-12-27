<?PHP

class NightsWatch {

	private $_pretenders;

	function __contruct()
	{
		$this->_pretenders = array();
	}

	function recruit($pretender)
	{
		$arr_interf = class_implements($pretender);
		if (isset($arr_interf["IFighter"]))
			$this->_pretenders[] = $pretender;
	}

	function fight()
	{
		foreach ($this->_pretenders as $prtdrs)
			$prtdrs->fight();
	}
}

?>