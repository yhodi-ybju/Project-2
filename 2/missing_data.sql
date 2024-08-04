SELECT
    *
FROM
    dm.loan_holiday_info
WHERE
    agreement_rk IS NULL
    AND account_rk IS NULL
    AND client_rk IS NULL
    AND department_rk IS NULL
    AND product_rk IS NULL
    AND product_name IS NULL
    AND deal_type_cd IS NULL
    AND deal_start_date IS NULL
    AND deal_name IS NULL
    AND deal_number IS NULL
    AND deal_sum IS NULL
    AND loan_holiday_finish_date IS NULL
    AND loan_holiday_fact_finish_date IS NULL;
