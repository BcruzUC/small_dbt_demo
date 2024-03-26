
with source as (
    --select * from {{source('main_data', 'raw_orders')}}
    select * from {{ref('raw_customers')}}
),

format_change as (
    select 
        id::int as id,
        first_name::text as user_name,
        last_name::text as user_lastname
    from source
)

select * from format_change