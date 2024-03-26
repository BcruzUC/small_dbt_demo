with payments as (
    select * from {{ref('stg_payments')}}
),

orders as (
    select * from {{ref('stg_orders')}}
),

customers as (
    select * from {{ref('stg_customers')}}
),

average_payment as (
    SELECT 
        sc.id AS user_id,
        sc.user_name || ' ' || sc.user_lastname as user_full_name,
        COUNT(so.id) AS order_quantity,
        ROUND(AVG(sp.payment_amount), 0) AS average_payment
    FROM customers sc
    LEFT JOIN orders so ON sc.id = so.user_id
    LEFT JOIN payments sp ON so.id = sp.order_id
    WHERE so.order_status = 'completed'
    GROUP BY sc.id, sc.user_name || ' ' || sc.user_lastname, so.order_date
    ORDER BY so.order_date
)

select * from average_payment