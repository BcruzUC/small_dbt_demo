
with source as (
    --select * from {{source('main_data', 'raw_orders')}}
    select * from {{ref('raw_payments')}}
),

format_change as (
    select 
        id::int as id,
        order_id::int as order_id,
        payment_method::text as payment_method,
        amount::int as payment_amount
    from source
)

select * from format_change