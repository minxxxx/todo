<?PHP

class House {

	function introduce()
	{
		echo "House ".static::getHouseName()." of ".static::getHouseSeat()." : \"".static::getHouseMotto()."\"\n";
	}
}

?>