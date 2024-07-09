{{ config(materialized='view') }}

with movie_wise_median_rating as (
    select
        movieId,
        percentile_cont(rating, 0.5) over (partition BY movieId) AS median_rating
      from {{ ref('ratings_curate') }}
 ),
 movie_wise_median_rating_with_count as (
    select
        movieId,
        count(movieId) as number_of_ratings,
        ANY_VALUE(median_rating) as median_rating
    from movie_wise_median_rating
    group by movieId
 )

select
   movies.original_title as title,
   movies.id as movie_id,
   ratings.number_of_ratings as number_of_ratings,
   ratings.median_rating as median_rating,
   RANK() OVER (ORDER BY ratings.median_rating DESC) AS rank
from {{ ref('movies_curate') }} as movies
inner join movie_wise_median_rating_with_count as ratings
on movies.id = ratings.movieId
