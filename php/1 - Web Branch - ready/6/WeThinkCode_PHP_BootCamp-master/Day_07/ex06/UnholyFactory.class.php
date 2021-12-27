<?php

include_once('Fighter.class.php');

class UnholyFactory
{
  private $_absorbed_fighters;

  function __construct()
  {
    $this->_absorbed_fighters = array();
  }

  function absorb($abzob)
  {
    if ($abzob instanceof Fighter)
    {
      if ($this->_hasAbsorbed($abzob)) {
        echo "(Factory already absorbed a fighter of type "
					   . $abzob . ")" . PHP_EOL;
      }
      else {
        $this->_absorbed_fighters[] = $abzob;
        echo "(Factory absorbed a fighter of type " . $abzob
					   . ")" . PHP_EOL;
      }
    }
    else {
        echo "(Factory can't absorb this, it's not a fighter)"
  				   . PHP_EOL;
      }
    }

    private function _hasAbsorbed($compare_to)
    {
      foreach ($this->_absorbed_fighters as $otherfighter)
      {
        if ($compare_to == $otherfighter)
        {
           return True;
        }
      }
      return False;
    }

    function fabricate($name)
    {
      foreach ($this->_absorbed_fighters as $otherfighter)
      {
        if ($otherfighter->name === $name)
        {
          echo "(Factory fabricates a fighter of type " . $otherfighter
  					   . ")" . PHP_EOL;
           return clone $otherfighter;
        }
      }
      echo "(Factory hasn't absorbed any fighter of type " . $name
  			   . ")" . PHP_EOL;
  		return null;
    }
}


 ?>
