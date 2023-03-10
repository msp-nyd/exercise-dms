-- QUARTERLY SALES REPORT AT CUSTOMER LEVEL
-- CUSTOMER_ID, SUM(AMOUNT), YEAR ,Q1,Q2,Q3,Q4

DROP VIEW IF EXISTS DM.REPORT_QUARTERLY_SALES_SUMMARY_BY_CUSTOMERS;

CREATE VIEW DM.REPORT_QUARTERLY_SALES_SUMMARY_BY_CUSTOMERS AS
SELECT
	CUSTOMER_ID,
	FIRST_NAME,
	LAST_NAME,
	YEAR,
	MAX(Q1) AS Q1_AMOUNT,
	MAX(Q2) AS Q2_AMOUNT,
	MAX(Q3) AS Q3_AMOUNT,
	MAX(Q4) AS Q4_AMOUNT,
	SUM(YEARLY_AMOUNT) AS YEARLY_AMOUNT
FROM
	(
	SELECT
		C.CUSTOMER_ID,
		C.FIRST_NAME,
		C.LAST_NAME,
		FO.YEAR,
		SUM(CASE WHEN QUARTER = 1 THEN FO.AMOUNT ELSE 0 END) AS Q1,
		SUM(CASE WHEN QUARTER = 2 THEN FO.AMOUNT ELSE 0 END) AS Q2,
		SUM(CASE WHEN QUARTER = 3 THEN FO.AMOUNT ELSE 0 END) AS Q3,
		SUM(CASE WHEN QUARTER = 4 THEN FO.AMOUNT ELSE 0 END) AS Q4,
		SUM(FO.AMOUNT) AS YEARLY_AMOUNT
	FROM
		DM.FACTORDERS FO
	JOIN DM.DIMCUSTOMERS C ON
		FO.CUSTOMER_ID = C.CUSTOMER_ID
	GROUP BY
		C.CUSTOMER_ID,
		C.FIRST_NAME,
		C.LAST_NAME,
		FO.YEAR,
		FO.QUARTER,
		FO.QUARTAL
) TBL
GROUP BY
	CUSTOMER_ID,
	FIRST_NAME,
	LAST_NAME,
	YEAR
ORDER BY
	CUSTOMER_ID,
	YEAR;

SELECT * FROM DM.REPORT_QUARTERLY_SALES_SUMMARY_BY_CUSTOMERS ORDER BY CUSTOMER_ID, YEAR;