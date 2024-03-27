with orders as (
    select * from {{ref('stg_orders')}}
),

customers as (
    select * from {{ref('stg_customers')}}
),

customer_data AS (
SELECT * FROM orders so
LEFT JOIN customers sc ON so.user_id = sc.id
WHERE order_status = 'completed'
),

indicator as (
SELECT
    current_month.month AS current_month,
    current_month.current_customers AS current_customers,
    COALESCE(previous_month.previous_customers, 0) AS previous_customers,
    CASE
        WHEN COALESCE(previous_month.previous_customers, 0) = 0 THEN NULL
        ELSE (current_month.current_customers::numeric / previous_month.previous_customers) * 100
    END AS proportion_to_previous_month
FROM
    (SELECT
         date_part('month', order_date) as month,
         COUNT(DISTINCT user_id) AS current_customers
     FROM
         customer_data
     GROUP BY
         month) AS current_month
LEFT JOIN
    (SELECT
         date_part('month', order_date) as month,
         COUNT(DISTINCT user_id) AS previous_customers
     FROM
         customer_data
     GROUP BY
         month) AS previous_month
ON
    current_month.month = previous_month.month + 1
ORDER BY
    current_month.month
)

select * from indicator
