<?PHP

class Targaryen {

	protected function resistsFire()
	{
		return false;
	}

	function getBurned()
	{
		if (static::resistsFire())
			return ("emerges naked but unharmed");
		else
			return ("burns alive");
	}
}

?>