
{% set source_relation = source('usa_marketting', 'CUSTOMER') %}
  
{{ notify_new_col_tbl(source_relation) }}

select
  *
from {{ source_relation }}