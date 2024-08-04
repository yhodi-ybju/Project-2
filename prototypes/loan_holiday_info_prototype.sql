with deal as (
select  deal_rk
	   ,deal_num --Номер сделки
	   ,deal_name --Наименование сделки
	   ,deal_sum --Сумма сделки
	   ,client_rk --Ссылка на клиента
	   ,agreement_rk --Ссылка на договор
	   ,deal_start_date --Дата начала действия сделки
	   ,department_rk --Ссылка на отделение
	   ,product_rk -- Ссылка на продукт
	   ,deal_type_cd
	   ,effective_from_date
	   ,effective_to_date
from RD.deal_info
), loan_holiday as (
select  deal_rk
	   ,loan_holiday_type_cd  --Ссылка на тип кредитных каникул
	   ,loan_holiday_start_date     --Дата начала кредитных каникул
	   ,loan_holiday_finish_date    --Дата окончания кредитных каникул
	   ,loan_holiday_fact_finish_date      --Дата окончания кредитных каникул фактическая
	   ,loan_holiday_finish_flg     --Признак прекращения кредитных каникул по инициативе заёмщика
	   ,loan_holiday_last_possible_date    --Последняя возможная дата кредитных каникул
	   ,effective_from_date
	   ,effective_to_date
from RD.loan_holiday
), product as (
select product_rk
	  ,product_name
	  ,effective_from_date
	  ,effective_to_date
from RD.product
), holiday_info as (
select   d.deal_rk
        ,lh.effective_from_date
        ,lh.effective_to_date
        ,d.deal_num as deal_number --Номер сделки
	    ,lh.loan_holiday_type_cd  --Ссылка на тип кредитных каникул
        ,lh.loan_holiday_start_date     --Дата начала кредитных каникул
        ,lh.loan_holiday_finish_date    --Дата окончания кредитных каникул
        ,lh.loan_holiday_fact_finish_date      --Дата окончания кредитных каникул фактическая
        ,lh.loan_holiday_finish_flg     --Признак прекращения кредитных каникул по инициативе заёмщика
        ,lh.loan_holiday_last_possible_date    --Последняя возможная дата кредитных каникул
        ,d.deal_name --Наименование сделки
        ,d.deal_sum --Сумма сделки
        ,d.client_rk --Ссылка на контрагента
        ,d.agreement_rk --Ссылка на договор
        ,d.deal_start_date --Дата начала действия сделки
        ,d.department_rk --Ссылка на ГО/филиал
        ,d.product_rk -- Ссылка на продукт
        ,p.product_name -- Наименование продукта
        ,d.deal_type_cd -- Наименование типа сделки
from deal d
left join loan_holiday lh on 1=1
                             and d.deal_rk = lh.deal_rk
                             and d.effective_from_date = lh.effective_from_date
left join product p on p.product_rk = d.product_rk
					   and p.effective_from_date = d.effective_from_date
)
SELECT deal_rk
      ,effective_from_date
      ,effective_to_date
      ,agreement_rk
      ,client_rk
      ,department_rk
      ,product_rk
      ,product_name
      ,deal_type_cd
      ,deal_start_date
      ,deal_name
      ,deal_number
      ,deal_sum
      ,loan_holiday_type_cd
      ,loan_holiday_start_date
      ,loan_holiday_finish_date
      ,loan_holiday_fact_finish_date
      ,loan_holiday_finish_flg
      ,loan_holiday_last_possible_date
FROM holiday_info