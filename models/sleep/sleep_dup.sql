select dateOfSleep, count(*)  as cnt from {{ ref('sleep') }} group by dateOfSleep having cnt > 1
