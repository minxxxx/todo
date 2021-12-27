SELECT UPPER(fiche_personne.nom) AS NOM, fiche_personne.prenom, abonnement.prix
FROM fiche_personne
INNER JOIN membre ON membre.id_fiche_perso = fiche_personne.id_perso
INNER JOIN abonnement ON membre.id_abo = abonnement.id_abo
WHERE abonnement.prix > 42
ORDER BY fiche_personne.nom, fiche_personne.prenom;
