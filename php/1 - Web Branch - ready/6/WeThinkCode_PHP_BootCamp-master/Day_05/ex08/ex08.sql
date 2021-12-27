SELECT `last_name`, `first_name`, SUBSTRING(DATE(`birthdate`), 10) AS 'birthdate' FROM `user_card` WHERE YEAR(`birthdate`) = 1989 ORDER BY `last_name` ASC;
