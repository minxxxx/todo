SELECT DATEDIFF(MAX(DATE(`last_projection`)), MIN(DATE(`release_date`))) AS 'uptime' FROM `film` GROUP BY `id_film`;
