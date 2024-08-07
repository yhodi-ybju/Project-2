WITH next_day_balance AS (
    SELECT account_rk,
           effective_date,
           account_in_sum,
           account_out_sum,
           LEAD(account_in_sum) OVER (PARTITION BY account_rk ORDER BY effective_date) AS next_day_in_sum
      FROM rd.account_balance
)
SELECT account_rk,
       effective_date,
       account_in_sum,
       COALESCE(next_day_in_sum, account_out_sum) AS account_out_sum
  FROM next_day_balance;
