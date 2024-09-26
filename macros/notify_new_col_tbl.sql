{% macro notify_new_col_tbl(source_relation) %}

{% set get_previous_columns %}
  SELECT * from DBT_OUTPUT_DBT_OUTPUT.slack_notifications 
  where action_type = 'SOURCE' and source_table = '{{ source_relation }}';
{% endset %}
{% set result = run_query(get_previous_columns) %}


{% set previous_column_list = [] %} 

{% if result %}
  {% for row in result %}
    {% set previous_column_list = previous_column_list.append(row) %}
  {% endfor %}
{% endif %}
-- get the current column names
{% set current_columns = adapter.get_columns_in_relation(source_relation) %}

{% set new_columns = [] %} 

{% for column in current_columns %}
  {% if column.name not in previous_column_list %}
    {% set new_columns = new_columns.append(column.name)  %}
  {% endif %}
{% endfor %}


{% if new_columns %}
  {% set message1 = " " ~ ", ".join(new_columns)  %}
  {{ log(message1) }}

  {% set sql %}
    INSERT INTO DBT_OUTPUT_DBT_OUTPUT.slack_notifications (action_type,source_table,missing_columns)
    VALUES ('missing','{{ source_relation }}','{{ message1 }}');
  {% endset %}
  {% do run_query( sql ) %}

{% else %}
  {{ log("No missing columns found.") }}
{% endif %}



--deleteing previous columns related records
{% set delete_previous_columns %} 
  delete from DBT_OUTPUT_DBT_OUTPUT.slack_notifications 
  where action_type = 'SOURCE' and source_table = '{{ source_relation }}';
{% endset %}
{% do run_query( delete_previous_columns ) %}

--Prepair to insert current table and columns to the table
{% set insert_values = [] %}
{% for row in current_columns %}
    {% set insert_statement %}
        INSERT INTO DBT_OUTPUT_DBT_OUTPUT.slack_notifications (action_type,source_table,missing_columns)
        VALUES ('SOURCE','{{ source_relation }}', '{{ row['column'] }}');
    {% endset %}

    {% do run_query(insert_statement) %}
{% endfor %}



{% endmacro %}
