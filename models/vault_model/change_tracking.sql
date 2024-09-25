{% set source_relation = var('source.TITANIC') %}
{% set column_list = ['AGE', 'CABIN', 'EMBARKED', 'FARE', 'NAME', 'PARCH', 'PASSENGERID', 'PCLASS', 'SEX', 'SIBSP','SURVIVED'] %}

{{ notify_new_columns(source_relation, column_list) }}

{% set column_name = ", ".join(column_list) %}

select
  {{ column_name }}
from {{ source_relation }}

