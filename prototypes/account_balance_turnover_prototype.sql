SELECT a.account_rk,
	   COALESCE(dc.currency_name, '-1'::TEXT) AS currency_name,
	   a.department_rk,
	   ab.effective_date,
	   ab.account_in_sum,
	   ab.account_out_sum
FROM rd.account a
LEFT JOIN rd.account_balance ab ON a.account_rk = ab.account_rk
LEFT JOIN dm.dict_currency dc ON a.currency_cd = dc.currency_cd