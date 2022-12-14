# Select only the first customer which rented the most anount of movies
# I did'nt not assum that the customer_id or the actual amount is needed
SELECT 
	CONCAT(C.first_name, ' ' , C.last_name)
	#,R.customer_id
    #,COUNT(R.rental_date)
    #,C.first_name
    #,C.last_name
FROM 
	`sakila`.`rental` as R
INNER JOIN sakila.customer as c 
ON
	c.customer_id = R.customer_id
WHERE 
	YEAR(R.rental_date) = 2005
GROUP BY 
	R.customer_id
ORDER BY 
	COUNT(R.customer_id) DESC
LIMIT 1
;
