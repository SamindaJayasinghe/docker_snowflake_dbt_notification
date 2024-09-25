{% macro new_macro() %}
{% set source_relation = var('source.TITANIC') %}

{% set column_list = ['AGE', 'CABIN', 'EMBARKED', 'FARE', 'NAME', 'PARCH', 'PASSENGERID', 'PCLASS', 'SEX', 'SIBSP'] %}

{% set source_columns = adapter.get_columns_in_relation(source_relation) %}

{% set new_columns = [] %}

{% for column in source_columns %}
  {% if column.name not in column_list %}
    {% set new_columns = new_columns.append(column.name)  %}
  {% endif %}
{% endfor %}

{% set message1 = "All missing columns " ~ ", ".join(new_columns)  %}

{% if new_columns %}
  {{ log(message1) }}
  {% set r_message = message1 %}
{% else %}
  {{ log("No missing columns found.") }}
  {% set r_message = "No missing columns found." %}
{% endif %}

{% do log("The value is: " ~ r_message, info=True) %}
{{ return(r_message) }}
{% endmacro %}
