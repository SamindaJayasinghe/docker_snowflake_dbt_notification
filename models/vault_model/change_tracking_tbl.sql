
{% set source_relation = source('uk_sales', 'TITANIC') %}
  
{% set column_list = ['AGE', 'CABIN', 'EMBARKED', 'FARE', 'NAME', 'PARCH', 'PASSENGERID', 'PCLASS', 'SEX', 'SIBSP','SURVIVED'] %}

{{ notify_new_col_tbl(source_relation) }}

{% set column_name = ", ".join(column_list) %}

select
  {{ column_name }}
from {{ source_relation }}