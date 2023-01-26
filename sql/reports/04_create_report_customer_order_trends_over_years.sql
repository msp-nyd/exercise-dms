
-- Query to generate the yearly total trend line, showing Customers that didnot 
-- have orders in certain years, i.e. customer order trends
-- Currently pivoting using the static years, need to convert to dynamic pivot
WITH CTELINE AS(SELECT DISTINCT YEAR FROM DM.FACTORDERS ORDER BY 1)
SELECT 'SUM(CASE WHEN YEAR = ' || YEAR || ' THEN AMOUNT ELSE 0 END) AS Y' || YEAR || '_AMOUNT,' AS LINE FROM CTELINE;
-- Below cteline helps manually getting all the years with the data points 
-- Can be converted to a SP to ALTER the view by adding max(year)+1 year
-- So if we donot have any data point for additional year, it will still keep the 
-- original new year or we can also generate years upto current year


DROP VIEW IF EXISTS DM.REPORT_CUSTOMER_ORDER_TRENDS_OVER_YEARS;

CREATE VIEW DM.REPORT_CUSTOMER_ORDER_TRENDS_OVER_YEARS AS
WITH CTE AS(
SELECT
	SUM(AMOUNT) AS GRAND_ORDER_TOTAL_AMOUNT
FROM
	DM.FACTORDERS)
SELECT
	*
FROM
	(
	SELECT
		CONCAT(C.FIRST_NAME, ' ', C.LAST_NAME) AS CUSTOMERNAME,
		SUM(SO.AMOUNT) AS TOTAL_ORDER_AMOUNT,
		CAST((SUM(SO.AMOUNT)/ CTE.GRAND_ORDER_TOTAL_AMOUNT)* 100 AS NUMERIC(10, 4)) AS ORDER_AMOUNT_PERCENTAGE,
		-- COPY THE RESULT OF ALL LINE COLUMNS FROM ABOVE CTELINE 
		SUM(CASE WHEN YEAR = 2013 THEN AMOUNT ELSE 0 END) AS Y2013_AMOUNT,
		SUM(CASE WHEN YEAR = 2014 THEN AMOUNT ELSE 0 END) AS Y2014_AMOUNT,
		SUM(CASE WHEN YEAR = 2015 THEN AMOUNT ELSE 0 END) AS Y2015_AMOUNT,
		SUM(CASE WHEN YEAR = 2016 THEN AMOUNT ELSE 0 END) AS Y2016_AMOUNT,
		SUM(CASE WHEN YEAR = 2017 THEN AMOUNT ELSE 0 END) AS Y2017_AMOUNT,
		C.CUSTOMER_ID
	FROM
		CTE,
		DM.FACTORDERS SO
	JOIN DM.DIMCUSTOMERS C ON
		C.CUSTOMER_ID = SO.CUSTOMER_ID
	GROUP BY
		C.CUSTOMER_ID,
		C.FIRST_NAME,
		C.LAST_NAME,
		GRAND_ORDER_TOTAL_AMOUNT
) TBL
ORDER BY
	ORDER_AMOUNT_PERCENTAGE DESC,
	Y2017_AMOUNT,
	Y2016_AMOUNT,
	Y2015_AMOUNT,
	Y2014_AMOUNT,
	Y2013_AMOUNT,
	TOTAL_ORDER_AMOUNT DESC;

SELECT * FROM DM.REPORT_CUSTOMER_ORDER_TRENDS_OVER_YEARS ORDER BY ORDER_AMOUNT_PERCENTAGE DESC,Y2017_AMOUNT,Y2016_AMOUNT,Y2015_AMOUNT,Y2014_AMOUNT,Y2013_AMOUNT,TOTAL_ORDER_AMOUNT DESC;