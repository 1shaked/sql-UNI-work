# select and UNOIN the actors and the customers which don't have a matching name
# select customers id, name and the type is if customer or actor join with the actors table
# the process is to create and join the two tables and check if the customer name is not in the actors first names
# also the the same thing but to the actor 
# and then unioin them what unoin does is return the to tables toghter.
# ** I could use also with statment here but I thought about that but decided it will not make anything more simple
# also I added the type of name that will tell us where the data came from
SELECT 
	C.customer_id as ID
	,C.first_name
    ,'CUSTOMER' as "type of name"
FROM sakila.customer AS C
WHERE
	C.first_name NOT IN (
		# sub query that get the DISTINCT first name of the actors.
		SELECT 
			DISTINCT(A.first_name)
		FROM 
			sakila.actor as A        
    )
GROUP BY C.customer_id
UNION ALL
SELECT 
	A.actor_id
	,A.first_name
    ,'ACTOR' as "type of name"
FROM sakila.actor as A
WHERE
	A.first_name NOT IN (
		# sub query that get the DISTINCT first name of the customers.
		SELECT 
			distinct(C.first_name)
        FROM 
			sakila.customer as C
    )
GROUP BY A.actor_id


