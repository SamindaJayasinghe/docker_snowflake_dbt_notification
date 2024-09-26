{{ config(
    materialized='table'
) }}


select 
    cast(null as varchar(100)) as action_type,
    cast(null as varchar(100)) as source_table,
    cast(null as nvarchar(1000)) as missing_columns

