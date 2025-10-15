SELECT
  target.REC_HIST_GID      AS tgt_rec_hist_gid,
  recal.REC_HIST_GID       AS src_rec_hist_gid,
  target.GPI_10_CD         AS tgt_gpi10,
  recal.recal_GPI_10_CD    AS src_gpi10,
  CLM.GPI_CD               AS src_gpi_full,
  target.SRC_TMZN_CD,
  recal.recal_SRC_TMZN_CD,
  target.*
FROM comparison
JOIN `...sdl.T_NON_FRMLY_MEDD_QL` target USING(<your string-cast key columns>)
JOIN recalculated_kpis recal USING(<same columns>)
JOIN `...cnf.T_PHMCY_CLM_DLY_FACT` CLM
  ON CLM.REC_HIST_GID = recal.REC_HIST_GID  -- or the correct key
WHERE (GPI_10_CD_match = 0 OR REC_HIST_GID_match = 0)
LIMIT 200;
