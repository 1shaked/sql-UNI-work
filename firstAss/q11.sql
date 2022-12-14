# Create a temp table to get the storeId, amount, yearAndMonth with a goup by the store id and the yeaer and month
# we join stuff and  payment table such that there is the same staff id and we check the total amount payed
# the reason we return the min payment date bacuse we want a date that is in that month.
USE sakila;
WITH EarnningsPerMonth(storeId, amount, yearAndMonth) AS (
	SELECT 
		S.store_id
		,SUM(P.amount)
		# ,DATE_FORMAT(P.payment_date, '%Y.%m') as yearAndMonth
        ,MIN(P.payment_date)
	FROM sakila.staff AS S
	INNER JOIN sakila.payment as P ON
		S.staff_id = P.staff_id
	GROUP BY 
		S.store_id
		,DATE_FORMAT(P.payment_date, '%Y.%m')
)
SELECT 
	E.storeId
    ,E.amount
    ,DATE_FORMAT(E.yearAndMonth, "%Y.%m") as 'date'
    # ,EP.amount as prevAmount
    # ,EP.yearAndMonth
    ,E.amount - EP.amount as "earning difference"
FROM 
	EarnningsPerMonth as E
INNER JOIN EarnningsPerMonth as EP ON # stans for earrning previous 
	E.storeId = EP.storeId
    # this will help us that the date is the same 
    AND DATE_FORMAT(DATE_ADD(EP.yearAndMonth, INTERVAL 1 MONTH), '%Y.%m') = DATE_FORMAT(E.yearAndMonth, '%Y.%m')
	# ** THIS IS ANOTHER OPTION INSTAND OF THE LINE BEFORE AND UNCOMMENT  THE NEXT TWO LINE
    # AND MONTH(DATE_ADD(EP.yearAndMonth, INTERVAL 1 MONTH)) = MONTH(E.yearAndMonth)
	# AND YEAR(DATE_ADD(EP.yearAndMonth, INTERVAL 1 MONTH))  = YEAR(E.yearAndMonth)

ORDER BY 
	# to enfore that the top row is the hightes diffrent
	E.amount - EP.amount DESC

# I was 95% sure you wanted only the top row
LIMIT 1
;