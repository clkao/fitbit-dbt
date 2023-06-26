---{{ config(materialized='table') }}
{{ config(materialized='external', location='target/sleep_dedup.csv') }}

{{ dbt_utils.deduplicate(
    relation=ref('sleep'),
    partition_by='dateOfSleep, mainSleep, startTime, endTime, logType',
    order_by='startTime asc, endTime asc'
   )
}}
