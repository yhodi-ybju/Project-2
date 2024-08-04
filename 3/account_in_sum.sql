WITH prev_day_balance AS (
    SELECT
        account_rk,
        effective_date,
        LAG(account_out_sum) OVER (PARTITION BY account_rk ORDER BY effective_date) AS prev_day_out_sum
    FROM
        rd.account_balance
)
SELECT
    ab.account_rk,
    ab.effective_date,
    COALESCE(prev_day_balance.prev_day_out_sum, ab.account_in_sum) AS correct_account_in_sum,
    ab.account_out_sum
FROM
    rd.account_balance ab
LEFT JOIN
    prev_day_balance prev_day_balance
ON
    ab.account_rk = prev_day_balance.account_rk
AND
    ab.effective_date = prev_day_balance.effective_date + INTERVAL '1 day'
WHERE
    ab.account_in_sum IS DISTINCT FROM prev_day_balance.prev_day_out_sum;
