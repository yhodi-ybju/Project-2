WITH next_day_balance AS (
    SELECT
        account_rk,
        effective_date,
        LEAD(account_in_sum) OVER (PARTITION BY account_rk ORDER BY effective_date) AS next_day_in_sum
    FROM
        rd.account_balance
)
SELECT
    ab.account_rk,
    ab.effective_date,
    ab.account_in_sum,
    COALESCE(next_day_balance.next_day_in_sum, ab.account_out_sum) AS correct_account_out_sum
FROM
    rd.account_balance ab
LEFT JOIN
    next_day_balance next_day_balance
ON
    ab.account_rk = next_day_balance.account_rk
AND
    ab.effective_date = next_day_balance.effective_date - INTERVAL '1 day'
WHERE
    ab.account_out_sum IS DISTINCT FROM next_day_balance.next_day_in_sum;
