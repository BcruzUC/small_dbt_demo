
with source as (
    --select * from {{source('main_data', 'raw_orders')}}
    select * from {{ref('raw_orders')}}
),

date_separation as (
    select 
        id::int as id,
        user_id::int as user_id,
        order_date::date as order_date,
        status::text as order_status
    from source
)

select * from date_separation