{% set cols = ['nights_booked', 'booking_id', 'booking_amount'] %}

-- This is for adding columns into the select statement without having to write the names again and again
-- so all the columns in the set statement will be prnted in the select statement within the for loop


select 
{% for col in cols %}

{{col}}

{% if not loop.last %} ,  -- added this for not adding comma in the end of the last column for it for run dynamically
-- so it says if the last item in the loop is not the last then add the comma else no comma


{% endif %}

{% endfor %}

from {{ ref ('bronze_bookings') }}


