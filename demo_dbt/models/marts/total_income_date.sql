with payments as (
    select * from {{ref('stg_payments')}}
),

orders as (
    select * from {{ref('stg_orders')}}
),

total_income as (
    SELECT
        so.order_date,
        SUM(payment_amount) AS total_day,
        COUNT(DISTINCT order_id) AS total_orders
    FROM payments sp
    LEFT JOIN orders so ON sp.order_id = so.id
    WHERE so.order_status = 'completed'
    GROUP BY so.order_date
)

select * from total_income