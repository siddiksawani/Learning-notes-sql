WITH w AS (
  SELECT
    DATE_TRUNC(DATE_SUB(CURRENT_DATE('America/Phoenix'), INTERVAL 40 MONTH), MONTH) AS dt_start,
    DATE_SUB(DATE_TRUNC(CURRENT_DATE('America/Phoenix'), MONTH), INTERVAL 1 DAY)    AS dt_end
)

, q1 AS (
  SELECT COUNT(*) AS duplicate_group_count
  FROM (
    SELECT
      LVL1_ACCT_GID, LVL3_ACCT_GID, MBR_ACCT_ID, FILL_DT,
      FRMLY_NDC_EFF_DT, FRMLY_NDC_EXPRN_DT, GPI_10_CD, SRC_FRMLY_PDCL_CD
    FROM `edp-ga-restrict-pbmstorage.edp_custrpt_pbmedh_sdl.T_NON_FRMLY_MEDD_QL`, w
    WHERE FILL_DT BETWEEN w.dt_start AND w.dt_end
    GROUP BY 1,2,3,4,5,6,7,8
    HAVING COUNT(*) > 1
  )
)

, q2 AS (
  SELECT
    COUNT(*) AS duplicate_group_count,
    SUM(r_count) AS total_duplicate_rows
  FROM (
    SELECT REC_HIST_GID, COUNT(*) AS r_count
    FROM `edp-ga-restrict-pbmstorage.edp_custrpt_pbmedh_sdl.T_NON_FRMLY_MEDD_QL`, w
    WHERE FILL_DT BETWEEN w.dt_start AND w.dt_end
    GROUP BY REC_HIST_GID
    HAVING COUNT(*) > 1
  )
)

SELECT 'q1_business_key_groups' AS metric, duplicate_group_count FROM q1
UNION ALL
SELECT 'q2_rec_hist_gid_groups', duplicate_group_count FROM q2
UNION ALL
SELECT 'q2_total_duplicate_rows', total_duplicate_rows FROM q2;
