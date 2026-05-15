{% set flag = 2  %}


select * from {{ ref ('bronze_bookings')}}
{%if flag == 2 %}
where nights_booked > 1
{% else %}
where nights_booked = 1
{% endif %}
