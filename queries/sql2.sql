-- Params
DECLARE yyyy INT64 DEFAULT 2025;
DECLARE mm   INT64 DEFAULT 9;
DECLARE dd   INT64 DEFAULT 31;  

WITH req AS (
  SELECT SAFE.PARSE_DATE('%Y-%m-%d', FORMAT('%04d-%02d-%02d', yyyy, mm, dd)) AS requested_dt,
         DATE_SUB(DATE_ADD(DATE(yyyy, mm, 1), INTERVAL 1 MONTH), INTERVAL 1 DAY) AS month_end_dt
),
pick AS (
  SELECT COALESCE(requested_dt, month_end_dt) AS check_dt,
         requested_dt IS NULL AS was_invalid
  FROM req
)
SELECT
  check_dt,
  was_invalid AS requested_date_invalid,
  COUNTIF(t.FILL_DT = check_dt) AS row_count
FROM pick
LEFT JOIN `edp-qa-restrict-pbmstorage.edp_custrpt_pbmedh_cnf.T_PHMCY_CLM_DLY_FACT` t
ON TRUE;
