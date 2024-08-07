WITH previous_day_balance AS (
    SELECT account_rk,
           effective_date,
           account_in_sum,
           account_out_sum,
           LAG(account_out_sum) OVER (PARTITION BY account_rk ORDER BY effective_date) AS prev_day_out_sum
      FROM rd.account_balance
)
SELECT account_rk,
       effective_date,
       COALESCE(prev_day_out_sum, account_in_sum) AS account_in_sum,
       account_out_sum
  FROM previous_day_balance;

