WITH CTE AS (
    SELECT
        ctid,
        client_rk,
        effective_from_date,
        ROW_NUMBER() OVER (PARTITION BY client_rk, effective_from_date ORDER BY client_rk, effective_from_date) AS row_num
    FROM
        dm.client
)
DELETE FROM dm.client
WHERE ctid IN (
    SELECT ctid
    FROM CTE
    WHERE row_num > 1
);
