-- 02_create_date_dimension.sql

DROP TABLE IF EXISTS DM.DIMDATE;

CREATE TABLE DM.DIMDATE (
	DATEKEY INT4 NULL,
	"DATE" DATE NULL,
	EPOCH NUMERIC NULL,
	"YEAR" NUMERIC NULL,
	DAYOFYEAR NUMERIC NULL,
	"MONTH" NUMERIC NULL,
	MONTHNAME TEXT NULL,
	MONTHNAMESHORT TEXT NULL,
	"DAY" NUMERIC NULL,
	DAY_SUFFIX TEXT NULL,
	WEEKDAYNAME TEXT NULL,
	WEEKOFDAY NUMERIC NULL,
	WEEKOFMONTH INT4 NULL,
	WEEKOFYEAR NUMERIC NULL,
	FORMATTEDDATE TEXT NULL,
	QUARTER_ACTUAL NUMERIC NULL,
	QUARTAL TEXT NULL,
	QUARTER_NAME TEXT NULL,
	DAY_OF_QUARTER INT4 NULL,
	YEARQUARTAL TEXT NULL,
	YEARMONTH TEXT NULL,
	YEARCALENDARWEEK TEXT NULL,
	WEEKEND TEXT NULL,
	AMERICANHOLIDAY TEXT NULL,
	CWSTART DATE NULL,
	CWEND DATE NULL,
	MONTHSTART DATE NULL,
	MONTHEND TIMESTAMP NULL,
	FIRST_DAY_OF_WEEK DATE NULL,
	LAST_DAY_OF_WEEK DATE NULL,
	FIRST_DAY_OF_MONTH DATE NULL,
	LAST_DAY_OF_MONTH DATE NULL,
	FIRST_DAY_OF_QUARTER DATE NULL,
	LAST_DAY_OF_QUARTER DATE NULL,
	FIRST_DAY_OF_YEAR DATE NULL,
	LAST_DAY_OF_YEAR DATE NULL,
	MMYYYY TEXT NULL,
	MMDDYYYY TEXT NULL,
  PRIMARY KEY (DATEKEY)
);


INSERT INTO DM.DIMDATE
(DATEKEY, "DATE", EPOCH, "YEAR", DAYOFYEAR, "MONTH", MONTHNAME, MONTHNAMESHORT, "DAY", DAY_SUFFIX, WEEKDAYNAME, WEEKOFDAY, WEEKOFMONTH, WEEKOFYEAR, FORMATTEDDATE, QUARTER_ACTUAL, QUARTAL, QUARTER_NAME, DAY_OF_QUARTER, YEARQUARTAL, YEARMONTH, YEARCALENDARWEEK, WEEKEND, AMERICANHOLIDAY, CWSTART, CWEND, MONTHSTART, MONTHEND, FIRST_DAY_OF_WEEK, LAST_DAY_OF_WEEK, FIRST_DAY_OF_MONTH, LAST_DAY_OF_MONTH, FIRST_DAY_OF_QUARTER, LAST_DAY_OF_QUARTER, FIRST_DAY_OF_YEAR, LAST_DAY_OF_YEAR, MMYYYY, MMDDYYYY)
SELECT
TO_CHAR(DATUM, 'YYYYMMDD')::INT AS DATEKEY,
DATUM AS DATE,
EXTRACT(EPOCH FROM DATUM) AS EPOCH,
EXTRACT(YEAR FROM DATUM) AS YEAR,
EXTRACT(DOY FROM DATUM) AS DAYOFYEAR,	
EXTRACT(MONTH FROM DATUM) AS MONTH,
TO_CHAR(DATUM, 'TMMONTH') AS MONTHNAME,
TO_CHAR(DATUM, 'MON') AS MONTHNAMESHORT,
EXTRACT(DAY FROM DATUM) AS DAY,
TO_CHAR(DATUM, 'FMDDTH') AS DAY_SUFFIX,
-- LOCALIZED WEEKDAY
TO_CHAR(DATUM, 'TMDAY') AS WEEKDAYNAME,
EXTRACT(ISODOW FROM DATUM) AS WEEKOFDAY,
TO_CHAR(DATUM, 'W')::INT AS WEEKOFMONTH,
EXTRACT(WEEK FROM DATUM) AS WEEKOFYEAR,
-- ISO CALENDAR WEEK
TO_CHAR(DATUM, 'DD. MM. YYYY') AS FORMATTEDDATE,
EXTRACT(QUARTER FROM DATUM) AS QUARTER_ACTUAL,
'Q' || TO_CHAR(DATUM, 'Q') AS QUARTAL,
CASE
   WHEN EXTRACT(QUARTER FROM DATUM) = 1 THEN 'FIRST'
   WHEN EXTRACT(QUARTER FROM DATUM) = 2 THEN 'SECOND'
   WHEN EXTRACT(QUARTER FROM DATUM) = 3 THEN 'THIRD'
   WHEN EXTRACT(QUARTER FROM DATUM) = 4 THEN 'FOURTH'
END AS QUARTER_NAME,
DATUM - DATE_TRUNC('QUARTER', DATUM)::DATE + 1 AS DAY_OF_QUARTER,
TO_CHAR(DATUM, 'YYYY/"Q"Q') AS YEARQUARTAL,
TO_CHAR(DATUM, 'YYYY/MM') AS YEARMONTH,
-- ISO CALENDAR YEAR AND WEEK
TO_CHAR(DATUM, 'IYYY/IW') AS YEARCALENDARWEEK,
CASE WHEN EXTRACT(ISODOW FROM DATUM) IN (6, 7) THEN 'WEEKEND' ELSE 'WEEKDAY' END AS WEEKEND,
-- FIXED HOLIDAYS FOR AMERICA
CASE WHEN TO_CHAR(DATUM, 'MMDD') IN ('0101', '0704', '1225', '1226') THEN 'HOLIDAY' ELSE '' END AS AMERICANHOLIDAY,
DATUM + (1 - EXTRACT(ISODOW FROM DATUM))::INTEGER AS CWSTART,
DATUM + (7 - EXTRACT(ISODOW FROM DATUM))::INTEGER AS CWEND,
-- START AND END OF THE MONTH OF THIS DATE
DATUM + (1 - EXTRACT(DAY FROM DATUM))::INTEGER AS MONTHSTART,
(DATUM + (1 - EXTRACT(DAY FROM DATUM))::INTEGER + '1 MONTH'::INTERVAL)::DATE - '1 DAY'::INTERVAL AS MONTHEND,
DATUM + (1 - EXTRACT(ISODOW FROM DATUM))::INT AS FIRST_DAY_OF_WEEK,
DATUM + (7 - EXTRACT(ISODOW FROM DATUM))::INT AS LAST_DAY_OF_WEEK,
DATUM + (1 - EXTRACT(DAY FROM DATUM))::INT AS FIRST_DAY_OF_MONTH,
(DATE_TRUNC('MONTH', DATUM) + INTERVAL '1 MONTH - 1 DAY')::DATE AS LAST_DAY_OF_MONTH,
DATE_TRUNC('QUARTER', DATUM)::DATE AS FIRST_DAY_OF_QUARTER,
(DATE_TRUNC('QUARTER', DATUM) + INTERVAL '3 MONTH - 1 DAY')::DATE AS LAST_DAY_OF_QUARTER,
TO_DATE(EXTRACT(YEAR FROM DATUM) || '-01-01', 'YYYY-MM-DD') AS FIRST_DAY_OF_YEAR,
TO_DATE(EXTRACT(YEAR FROM DATUM) || '-12-31', 'YYYY-MM-DD') AS LAST_DAY_OF_YEAR,
TO_CHAR(DATUM, 'MMYYYY') AS MMYYYY,
TO_CHAR(DATUM, 'MMDDYYYY') AS MMDDYYYY
FROM (SELECT '1970-01-01'::DATE + SEQUENCE.DAY AS DATUM
      FROM GENERATE_SERIES(0, 29219) AS SEQUENCE (DAY)
      GROUP BY SEQUENCE.DAY) DQ
ORDER BY 1; 