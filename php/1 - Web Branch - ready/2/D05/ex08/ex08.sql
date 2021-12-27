SELECT nom, prenom, DATE(date_naissance) AS "date de naissance"
FROM fiche_personne
WHERE DATE_FORMAT(date_naissance, "%Y") = 1989
ORDER BY nom;
