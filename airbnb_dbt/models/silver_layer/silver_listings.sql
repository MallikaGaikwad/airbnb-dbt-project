{{
    config(
        materialized = 'incremental', 
        unique_key = 'listing_id'
    )
}}

SELECT 
    listing_id
    ,host_id
    ,property_Type
    ,room_type
    ,city
    ,country
    ,accommodates
    ,bedrooms
    ,bathrooms
    ,price_per_night
    ,{{ tag('price_per_night') }} as price_per_night_tag
    ,created_at
FROM {{ ref ('bronze_listings') }}

