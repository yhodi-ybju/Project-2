WITH correct_balance AS (
    SELECT ab.account_rk,
           ab.effective_date + INTERVAL '1 day' AS next_day,
           ab.account_out_sum
      FROM rd.account_balance ab
)
UPDATE rd.account_balance ab
   SET account_in_sum = COALESCE(cb.account_out_sum, ab.account_in_sum)
  FROM correct_balance cb
 WHERE ab.account_rk = cb.account_rk
   AND ab.effective_date = cb.next_day;
