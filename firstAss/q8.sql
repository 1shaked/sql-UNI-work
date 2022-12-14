# select and UNOIN the actors and the customers which don't have a matching name
# select customers id, name and the type is if customer or actor join with the actors table
SELECT 
	C.customer_id as ID
	,C.first_name
    ,'CUSTOMER' as typeOfName
FROM sakila.customer AS C
WHERE
	C.first_name NOT IN (
		# sub query that get the DISTINCT first name of the actors.
		SELECT 
			DISTINCT(A.first_name)
		FROM sakila.actor as A        
    )
GROUP BY C.customer_id
UNION ALL
SELECT 
	A.actor_id
	,A.first_name
    ,'ACTOR' as typeOfName
FROM sakila.actor as A
WHERE
	A.first_name NOT IN (
		# sub query that get the DISTINCT first name of the customers.
		SELECT distinct(C.first_name)
        FROM sakila.customer as C
    )
GROUP BY A.actor_id


