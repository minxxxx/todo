#!/usr/bin/php
<?php
//https://intra.42.fr/forum/#!/WEB-1-001/Jour-02/Ex03-Par-ou-commencer
/*- lire le fichier /var/run/utmpx dans une chaine
- ignorer le header qui doit faire 1256 bytes
- boucler tant qu'on est pas à la fin de la chaine :
    - utiliser ce format bien moche pour unpack une structure utmpx : "a256login/a4id/a32line/ipid/itype/C8time/a256host/I16pad"
    - dans le champs login et line on a 2 des 3 infos qui nous interessent
    - ensuite dans les champs time[1-9] on a les 8 octets qui composent la structure timeval. Les 4 premiers sont ceux des secondes. avec strftime et ces secondes on peut formater la date qui nous interesse.
    - stocker l'entree dans un tableau si le login correspond à get_current_user()
    - avancer de 628 bytes dans la chaine
- trier le tableau
- afficher comme il faut
*/
if (($stream = fopen("/var/run/utmpx", "r")))
{
	fread($stream, 1256);
	$ret = array();
	while ($line = fread($stream, 1256/2))
	{
		$tab = unpack("a256login/a4id/a32line/ipid/itype/itime/a256host/I16pad", $line);
		$tab["login"] = substr($tab["login"], 0, strpos($tab["login"], "\0"));
		if ($tab["login"] == get_current_user() && $tab['type'] == 7)
		{
			$tab["line"] = substr($tab["line"], 0, strpos($tab["line"], "\0"));
			$ret[$tab["line"]] = $tab["time"];
		}
	}
	if (ksort($ret) == TRUE)
	{
		date_default_timezone_set("Europe/Paris");
		foreach($ret as $k => $v)
			printf("%-8s %-8s %s \n", get_current_user(), $k, date("M  j H:i", $v));
	}
	fclose($stream);
}
?>
