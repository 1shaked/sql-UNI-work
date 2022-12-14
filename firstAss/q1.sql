# assume we needed to lower the text so word like Aa can not appear in the category name
SELECT 
	# c.category_id # if you want to show the category id just uncomment the line
    ,c.name
FROM sakila.category as c
WHERE 
	# lower the name col and check if the string contain a only one time
	LOWER(NAME) REGEXP '^[^a]*a[^a]*$'
    # another option to implement the same function just comment line 8 and uncomment line 10 
    # LOWER(NAME) like '%a%' AND LOWER(NAME) NOT LIKE '%a%a%'
ORDER BY name
;