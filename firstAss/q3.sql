SELECT 
	f.film_id,
    f.title,
    t.title
FROM 
	sakila.film as f
JOIN sakila.film_text as t 
ON 
	t.film_id = f.film_id   
	AND t.title != f.title
ORDER BY 
	f.title ASC
;