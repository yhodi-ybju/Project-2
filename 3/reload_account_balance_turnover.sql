CREATE OR REPLACE PROCEDURE dm.reload_account_balance_turnover()
LANGUAGE plpgsql
AS $$
BEGIN
    TRUNCATE TABLE dm.account_balance_turnover;

    INSERT INTO dm.account_balance_turnover (
        account_rk,
        currency_name,
        department_rk,
        effective_date,
        account_in_sum,
        account_out_sum
    )
    SELECT
        acc.account_rk,
        COALESCE(curr.currency_name, 0) AS currency_name,
        acc.department_rk,
        bal.effective_date,
        bal.account_in_sum,
        bal.account_out_sum
    FROM rd.account acc
    LEFT JOIN rd.account_balance bal ON acc.account_rk = bal.account_rk
    LEFT JOIN dm.dict_currency curr ON acc.currency_cd = curr.currency_cd;
END;
$$;

CALL dm.reload_account_balance_turnover();
