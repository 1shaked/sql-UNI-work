# assume that all kind of PG are valid and checked with distinct comnnad what kind of G are there and there is only G with no 
# specific age ...
SELECT 
	film_id
	,title
    # if you want the length just uncomment
    # ,F.length
    # ,rating
    
FROM sakila.film as F
WHERE 
	# filter the length of the movie
    # I understand that the length have to be less then 90 minutes and not equal to 90
	F.length < 90
    # filter for rating with the string G or PG and contain all ages
	AND ( rating like 'G%'
    OR rating like 'PG%'
    )

;