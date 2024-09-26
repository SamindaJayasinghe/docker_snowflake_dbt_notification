{% macro notify_new_col_tbl(source_relation) %}

-- delete the previous missing columns message
{% set clear_previous_missing %}
  delete from dbt_output_dbt_output.slack_notifications
  where action_type = 'missing' and source_table = '{{ source_relation }}'
{% endset %}
{% do run_query( clear_previous_missing ) %}

-- get the previous column names
{% set get_previous_columns %}
  SELECT missing_columns from DBT_OUTPUT_DBT_OUTPUT.slack_notifications 
  where action_type = 'SOURCE' and source_table = '{{ source_relation }}';
{% endset %}
{% set result = run_query(get_previous_columns) %}


{% set previous_column_list = [] %} 

{% if result %}
  {% for row in result %}
    {% set previous_column_list = previous_column_list.append(row[0]) %}
  {% endfor %}
{% endif %}
{{ print("previous check: " ~ previous_column_list ) }}


-- get the current column names
{% set current_columns = adapter.get_columns_in_relation(source_relation) %}

--compare and find missing columns
{% set missing_columns = [] %} 

{% for column in current_columns %}
  {% if column.name not in previous_column_list %}
    {% set missing_columns = missing_columns.append(column.name)  %}
  {% endif %}
{% endfor %}

--insert missing columns , if we find any
{% if missing_columns %}
  {% set message1 = " " ~ ", ".join(missing_columns)  %}
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

--Prepair to insert current table and columns to the table ( only one insert to insert a list)

{% set insert_values = [] %}

{% for row in current_columns %}
    {% set value = "('SOURCE', '" ~ source_relation ~ "', '" ~ row['column'] ~ "')" %}
    {% set insert_values = insert_values.append(value) %}
{% endfor %}

{% set insert_statement %}
    INSERT INTO DBT_OUTPUT_DBT_OUTPUT.slack_notifications (action_type, source_table, missing_columns)
    VALUES {{ insert_values | join(', ') }};
{% endset %}

{% do run_query(insert_statement) %}
{% endmacro %}