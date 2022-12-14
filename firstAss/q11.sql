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
    ,E.yearAndMonth
    ,EP.amount as prevAmount
    ,EP.yearAndMonth
    ,E.amount - EP.amount as Diffrent
    #,DATE_ADD(EP.yearAndMonth, INTERVAL 1 MONTH)
    #,DATE_ADD(E.yearAndMonth, INTERVAL 1 MONTH) as Eplus
FROM 
	EarnningsPerMonth as E
INNER JOIN EarnningsPerMonth as EP ON # stans for earrning previous 
	E.storeId = EP.storeId
    AND MONTH(DATE_ADD(EP.yearAndMonth, INTERVAL 1 MONTH)) = MONTH(E.yearAndMonth)
    AND YEAR(DATE_ADD(EP.yearAndMonth, INTERVAL 1 MONTH))  = YEAR(E.yearAndMonth)

ORDER BY 
	E.amount - EP.amount DESC

;