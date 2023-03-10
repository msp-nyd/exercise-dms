---------------------------------------------------------------------------
-- QUARTERLY SALES REPORT AT PRODUCT LEVEL
-- PRODUCT_NAME, SUM(AMOUNT), YEAR, Q

DROP VIEW IF EXISTS DM.REPORT_QUARTERLY_SALES_BY_PRODUCTS;

CREATE VIEW DM.REPORT_QUARTERLY_SALES_BY_PRODUCTS AS 
SELECT
	OD.PRODUCT_NAME,
	FOD.YEAR,
	FOD.QUARTER,
	FOD.QUARTAL,
	SUM(FOD.AMOUNT) AS QUARTERLY_AMOUNT
FROM
	DM.FACTORDERDETAIL FOD
	JOIN DM.DIMORDERDETAILS OD ON OD.ORDER_DETAIL_ID =FOD.ORDER_DETAIL_ID 
GROUP BY
	OD.PRODUCT_NAME,
	FOD.YEAR,
	FOD.QUARTER,
	FOD.QUARTAL
ORDER BY
	OD.PRODUCT_NAME,
	FOD.YEAR,
	FOD.QUARTER;

SELECT * FROM DM.REPORT_QUARTERLY_SALES_BY_PRODUCTS ORDER BY PRODUCT_NAME,YEAR,QUARTER;