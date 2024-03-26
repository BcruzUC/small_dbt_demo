-- FALTA FILTRAR POR LAS TRANSACCIONES EXITOSAS Y LAS NO EXITOSAS

with payments as (
    select * from {{ref('stg_payments')}}
),

orders as (
    select * from {{ref('stg_orders')}}
),

sum_by_order as (
    SELECT 
        so.id AS order_id,
        so.order_date,
        SUM(sp.payment_amount) AS total_order
    FROM orders so
    LEFT JOIN payments sp ON so.id = sp.order_id
    WHERE so.order_status = 'completed'
    GROUP BY so.id, so.order_date
),

average_payment_day as (
    select
        order_date,
        COUNT(order_id) as order_quantity,
        ROUND(AVG(total_order), 0) as average_payment_order
    from sum_by_order
    group by order_date
	order by order_date
)

select * from average_payment_day