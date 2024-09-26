{{
  config(
    materialized='table', 
    enabled=True
  )
}}

SELECT 
*
from {{ source('usa_marketting', 'ORDERS') }} 
