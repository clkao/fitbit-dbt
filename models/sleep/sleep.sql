{{     config(materialized='table')
}}

with raw_sleep as (

select dateOfSleep, mainSleep,
    startTime, endTime, logType
, levels
from 
{{ source('sleep', 'sleep_log') }}

)
    select dateOfSleep, mainSleep,
    date_diff('minute', dateOfSleep, startTime) as start_offset_min,
    date_diff('minute', dateOfSleep, endTime) as end_offset_min,
    startTime, endTime, logType
    , cast(coalesce(json_extract(levels, '$.summary.awake.minutes'), json_extract(levels, '$.summary.wake.minutes')) as int) as min_wake
    , cast(coalesce(json_extract(levels, '$.summary.deep.minutes'), json_extract(levels, '$.summary.asleep.minutes')) as int) as min_deep
    , cast(coalesce(json_extract(levels, '$.summary.light.minutes'), json_extract(levels, '$.summary.restless.minutes')) as int) as min_light
    , cast(coalesce(json_extract(levels, '$.summary.rem.minutes'), 0) as int) as min_rem
    from raw_sleep

where start_offset_min < 360

    order by 1
