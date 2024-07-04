
{{ config(materialized='incremental') }}

with ratings_raw as (
    select
       *
    from {{ source('movies_data_ravi','ratings_raw') }}
)

select
        CAST(userId as NUMERIC) as userId,
        CAST(movieId as NUMERIC) as movieId,
        CAST(rating as NUMERIC) as rating,
        CAST(timestamp as NUMERIC) as timestamp,
        CURRENT_DATE() as load_date

 from ratings_raw
