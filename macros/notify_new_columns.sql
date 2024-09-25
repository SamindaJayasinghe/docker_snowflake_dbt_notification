{% macro notify_new_columns(source_relation, column_list) %}

{% set source_columns = adapter.get_columns_in_relation(source_relation) %}

{% set new_columns = [] %}

{% for column in source_columns %}
  {% if column.name not in column_list %}
    {% set new_columns = new_columns.append(column.name)  %}
  {% endif %}
{% endfor %}

{% if new_columns %}
  {% set message1 = "All missing columns: " ~ ", ".join(new_columns)  %}
  {{ log(message1) }}
  {{ slack_notify(message1) }}
{% else %}
  {{ log("No missing columns found.") }}
{% endif %}

{#
  -- {% set command = "python slack2.py '" ~ message1 ~ "'" %}
  -- {% do run_query("! " ~ command) %}
--------------------------------------------------
-- {% set missing_columns = ", ".join(new_columns) %}
-- {log('message': missing_columns)}

-- {% if new_columns | length > 0 %}
--     {% set message1 = 'New columns detected in ' ~ source_relation.full_name ~ ': ' ~ missing_columns %}
--     {{ log("I am here3: " + message1) }}
--     {% do dbt.log_info(message1) %}
-- {% endif %}
    -- {% if execute %}
    --   {{ dbt_slack.notify('missing columns', source_relation.full_name, column.name) }}
    -- {% endif %}

--------------------------------------------- 
#}
{% endmacro %}
