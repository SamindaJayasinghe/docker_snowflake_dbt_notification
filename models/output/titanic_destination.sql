{{
  config(
    materialized='table', 
    enabled=True
  )
}}

SELECT 
PASSENGERID as passenger_id,
SURVIVED as servieved,
Name as name,
Age as age
from {{ ref('titanic') }} 
