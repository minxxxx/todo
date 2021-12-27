INSERT INTO ft_table(login, creation_date, `group`)
SELECT last_name, birthdate, 'other' FROM user_card
WHERE LENGTH(last_name) < 9
AND last_name LIKE '%a%'
ORDER BY last_name
LIMIT 10;
