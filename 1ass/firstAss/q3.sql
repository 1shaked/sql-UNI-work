SELECT 
	f.film_id,
    f.title as "film title",
    t.title as "film text title"
FROM 
	sakila.film as f
INNER JOIN sakila.film_text as t 
ON 
	# we will join the two tables on the same film id and the title will have to be diffrent
	t.film_id = f.film_id   
	AND t.title != f.title
    
ORDER BY 
	f.title ASC
;