
{{ config(
        materialized='incremental',
        unique_key=["userId","movieId"]
    )
}}

with ratings_raw as (
    select
       *
    from {{ source('movies_data_ravi','ratings_raw') }}
),
type_cast_ratings as (
    select
        CAST(userId as NUMERIC) as userId,
        CAST(movieId as NUMERIC) as movieId,
        CAST(rating as NUMERIC) as rating,
        CAST(timestamp as NUMERIC) as timestamp
    from ratings_raw
),
group_ratings as (
    select
          userId,
          movieId,
          MAX(timestamp) as timestamp
    from type_cast_ratings
    group BY userId, movieId
)

select
        tcr.userId as userId,
        tcr.movieId as movieId,
        tcr.rating as rating,
        tcr.timestamp as timestamp,
        CURRENT_DATE() as load_date
from group_ratings gr inner join type_cast_ratings as tcr
    on
        gr.timestamp = tcr.timestamp AND
        gr.userId = tcr.userId AND
        gr.movieId = tcr.movieId

{% if is_incremental() %}
    where tcr.timestamp >= (select max(timestamp) from {{ this }})
{% endif %}
