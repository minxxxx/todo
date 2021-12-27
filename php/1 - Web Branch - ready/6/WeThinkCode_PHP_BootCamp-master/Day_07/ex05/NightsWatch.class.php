<?php

include_once('IFighter.class.php');

class NightsWatch
{
  private $_nightw = array();

  public function recruit($recruited)
  {
       $this->_nightw[] = $recruited;
  }

  public function fight()
  {
    foreach ($this->_nightw as $recruited)
    {
        if ($recruited instanceof IFighter)
            $recruited->fight();
    }
  }
}

?>
