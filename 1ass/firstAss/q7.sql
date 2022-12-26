# selecting the longest film rental 
# return only the full name and the time of the ךongets film rental
SELECT 
	CONCAT(C.first_name, ' ', C.last_name) as FullName
    # this will get the time took and round the resualt.
    ,ROUND(TIMESTAMPDIFF(DAY,R.rental_date ,R.return_date ) / 7, 4)  as TimeTook 
FROM 
	sakila.rental as R
JOIN sakila.customer as C ON 
	C.customer_id = R.customer_id
WHERE 
	R.return_date IS NOT NULL
    # FILTER the time diffrent to be only the max one
	AND TIMESTAMPDIFF(SECOND,R.rental_date ,R.return_date) = (
		# SUB QUERY THAT GET THE MAX TIME DIFFRENT BETWEEN THE DATES 
		SELECT 
			MAX(TIMESTAMPDIFF(SECOND,RV.rental_date ,RV.return_date)) 
		FROM 
			sakila.rental as RV
		)

