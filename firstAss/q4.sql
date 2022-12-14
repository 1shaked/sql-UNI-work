# Select only the first customer which rented the most anount of movies
# I did'nt not assum that the customer_id or the actual amount is needed to be selected as it's not been specepy 
# we count for each custoemr how many time he rented a film and order by the descnding value of the amount rented and take only the first one.
SELECT 
	CONCAT(C.first_name, ' ' , C.last_name) as "full name"
FROM 
	sakila.rental as R
INNER JOIN sakila.customer as C
ON
	# we join beased on the customer id
	C.customer_id = R.customer_id
	# force the date to be may 2005
	AND YEAR(R.rental_date) = 2005
    AND MONTH(R.rental_date) = 5
GROUP BY 
	R.customer_id
ORDER BY 
	COUNT(R.rental_id) DESC
LIMIT 1
;
