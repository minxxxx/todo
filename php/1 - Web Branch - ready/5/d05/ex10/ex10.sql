SELECT f.titre "Titre", f.resum "Resume", f.annee_prod FROM film f INNER JOIN genre g ON f.id_genre = g.id_genre WHERE g.nom = 'erotic';