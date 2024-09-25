{{ config(
    materialized='table',
    on_schema_change='drop'
) }}

select 
    cast(null as varchar(100)) as source_table,
    cast(null as nvarchar(1000)) as missing_columns

