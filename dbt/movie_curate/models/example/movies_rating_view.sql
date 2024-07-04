{{ config(materialized='view') }}

with movie_wise_media_rating as (select
  movieId,
  COUNT(movieId) as number_of_ratings,
  ANY_VALUE(median_rating) as median_rating
FROM (
  SELECT
    movieId,
    PERCENTILE_CONT(rating, 0.5) OVER (PARTITION BY movieId) AS median_rating
  FROM {{ ref('ratings_curate') }}
 )
GROUP BY
  movieId
)

select
   movies.original_title as title,
   movies.id as movie_id,
   ratings.number_of_ratings as number_of_ratings,
   ratings.median_rating as median_rating,
   RANK() OVER (ORDER BY ratings.median_rating DESC) AS rank
from {{ ref('movies_curate') }} as movies
inner join movie_wise_media_rating as ratings
on movies.id = ratings.movieId
