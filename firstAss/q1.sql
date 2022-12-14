# assume we needed to lower the text so word like Aa can not appear in the category name
SELECT 
	c.category_id
    ,c.name
    # ,c.last_update
FROM sakila.category as c
WHERE 
	# lower the name col and check if the string contain a only one time
	LOWER(NAME) REGEXP '^[^a]*a[^a]*$'
    
    # LOWER(NAME) like '%a%' AND LOWER(NAME) NOT LIKE '%a%a%'
ORDER BY name
;