# assume that all kind of PG are valid and checked with distinct comnnad what kind of G are there and there is only G with no 
# specific age ...
SELECT 
	film_id
	,title
    ,F.length
    ,rating
    
FROM sakila.film as F
WHERE 
	# filter the length of the movie
	F.length <= 90
    # filter for rating with the string G or PG and contain all ages
	AND ( rating = 'G'
    OR rating like 'PG%'
    )

;