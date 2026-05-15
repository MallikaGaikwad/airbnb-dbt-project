{{config (materialized='incremental')}}

select * from {{ source('source_schema', 'hosts') }}

{% if is_incremental() %}
where created_at > 
( select coalesce(max(created_at), '1900-01-01'::timestamp_ntz)
    from {{ this }}
)
{% endif %}