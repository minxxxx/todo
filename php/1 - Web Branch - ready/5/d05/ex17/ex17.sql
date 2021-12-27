SELECT count(*) "nb_abo", FLOOR(AVG(prix)) "moy_abo", MOD(SUM(duree_abo), 42) "ft" FROM abonnement;
