-- Connect to md
ATTACH 'md:';

-- CREATE A DATABASE
CREATE DATABASE datacamp_demo;

-- CREATE view
CREATE VIEW datacamp_demo.netflix_view AS
SELECT
    *
FROM
    's3://duckdb-md-dataset-121/netflix_daily_top_10.parquet';

-- CREATE A TABLE
CREATE TABLE datacamp_demo.netflix AS
FROM 's3://duckdb-md-dataset-121/netflix_daily_top_10.parquet';

-- CREATE top 10
i -- Display the most popular TV Shows
create table datacamp_demo.netflix_top_shows as
SELECT
    Title,
    max("Days In Top 10")
from
    datacamp_demo.netflix
where
    Type = 'Movie'
GROUP BY
    Title
ORDER BY
    max("Days In Top 10") desc
limit
    5;

-- Check UI / show shares
