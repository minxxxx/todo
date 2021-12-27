<?PHP

class UnholyFactory {

	private $absorbed_name;
	private $absorbed_cls;
	private $fabricated;

	function __construct()
	{
		$this->absorbed = array();
		$this->fabricated = array();
	}

	private function already_absorbed($type)
	{
		foreach ($this->absorbed as $cn => $cl)
		{
			if ($cn === $type)
				return true;
		}
		return false;
	}

	function absorb($newfighter)
	{
		if (get_parent_class($newfighter) !== "Fighter")
		{
			echo "(Factory can't absorb this, it's not a fighter)\n";
			return ;
		}
		if ($this->already_absorbed($newfighter->cur_name))
		{
			echo "(Factory already absorbed a fighter of type ".$newfighter->cur_name.")\n";
			return ;
		}
		$this->absorbed[$newfighter->cur_name] = get_class($newfighter);
		echo "(Factory absorbed a fighter of type ".$newfighter->cur_name.")\n";
	}

	function fabricate($name)
	{
		if ($this->already_absorbed($name))
		{
			$this->fabricated[] = $name;
			echo "(Factory fabricates a fighter of type ".$name.")\n";
			return (new $this->absorbed[$name]);
		}
		else
		{
			echo "(Factory hasn't absorbed any fighter of type ".$name.")\n";
			return NULL;
		}		
	}
}

?>