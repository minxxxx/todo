<?PHP

abstract class Fighter {

	public $cur_name;

	function __construct($name)
	{
		$this->cur_name = $name;
	}

	abstract function fight($target);
}

?>