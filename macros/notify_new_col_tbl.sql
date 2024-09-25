{% macro notify_new_col_tbl(source_relation, column_list) %}

{% set source_columns = adapter.get_columns_in_relation(source_relation) %}

{% set new_columns = [] %}

{% for column in source_columns %}
  {% if column.name not in column_list %}
    {% set new_columns = new_columns.append(column.name)  %}
  {% endif %}
{% endfor %}

{% if new_columns %}
  {% set message1 = " " ~ ", ".join(new_columns)  %}
  {{ log(message1) }}

  {% set sql %}
    INSERT INTO DBT_OUTPUT_DBT_OUTPUT.slack_notifications (source_table,missing_columns)
    VALUES ('{{ source_relation }}','{{ message1 }}');
  {% endset %}
  {% do run_query( sql ) %}

{% else %}
  {{ log("No missing columns found.") }}
{% endif %}
{% endmacro %}
