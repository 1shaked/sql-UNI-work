# assumed you only needed the category id and the avg len
# assumed you did not want to join based on empty category that's way inner join
SELECT 
	C.category_id
    ,AVG(F.length) as AVGLength 
FROM 
	sakila.film_category as C
INNER JOIN sakila.film as F ON 
	F.film_id = C.film_id
GROUP BY 
	C.category_id