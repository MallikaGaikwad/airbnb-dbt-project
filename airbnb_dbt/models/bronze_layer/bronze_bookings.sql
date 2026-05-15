{{config (materialized='incremental')}}

select * from {{ source('source_schema', 'bookings') }}

{% if is_incremental() %}
where created_at > 
( select coalesce(max(created_at), '1900-01-01'::timestamp_ntz)
    from {{ this }}
)
{% endif %}
{# adding if is_incremental() %} … {% endif %}
The watermark WHERE runs only on incremental runs. 
On the first build (empty target) or dbt run --full-refresh, that block is skipped, so you load the full source instead of filtering against an empty {{ this }}.

Bronze as real incrementals
In dbt_project.yml, bronze models are incremental with incremental_strategy: append, so is_incremental() is true only when dbt is doing an incremental run (not on full refresh / first create).

Dropped incremental_flag
Behavior is driven by dbt’s run mode instead of a hard-coded flag. #} 