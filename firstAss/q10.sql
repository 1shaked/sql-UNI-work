# get the CONSTRAINT_NAME abd the type of it
SELECT 
	CONSTRAINT_NAME 
    ,CONSTRAINT_TYPE
FROM 
	INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE 
	TABLE_NAME='film';