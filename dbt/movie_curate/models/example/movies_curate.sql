
{{ config(materialized='table') }}

with movies_raw as (
    select
       *
    from {{ source('movies_data_ravi','movies_raw') }}
)

select
        SAFE_CAST(adult as boolean) as adult,
        safe.PARSE_JSON(belongs_to_collection) as belongs_to_collection,
        SAFE_CAST(budget as NUMERIC) as budget,
        JSON_QUERY_ARRAY(genres) as genres,
        homepage,
        SAFE_CAST(id as NUMERIC) as id,
        imdb_id,
        original_language,
        original_title,
        overview,
        SAFE_CAST(popularity as NUMERIC) as popularity,
        poster_path,
        JSON_QUERY_ARRAY(production_companies) as production_companies,
        JSON_QUERY_ARRAY(production_countries) as production_countries,
        PARSE_DATE('%Y-%m-%d', release_date) as release_date,
        SAFE_CAST(revenue as NUMERIC) as revenue,
        SAFE_CAST(runtime as NUMERIC) as runtime,
        JSON_QUERY_ARRAY(spoken_languages) as spoken_languages,
        status,
        tagline,
        title,
        SAFE_CAST(video as boolean) as video,
        SAFE_CAST(vote_average as NUMERIC) as vote_average,
        SAFE_CAST(vote_count as NUMERIC) as vote_count,
        CURRENT_DATE() as load_date
 from movies_raw
