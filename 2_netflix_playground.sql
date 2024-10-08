-- Magic over S3
FROM 's3://duckdb-md-dataset-121/netflix_daily_top_10.parquet';
DESCRIBE TABLE 's3://duckdb-md-dataset-121/netflix_daily_top_10.parquet';
-- What is happening ?
FROM duckdb_extensions();

-- Create a table from s3 parquet file
CREATE TABLE netflix AS SELECT * FROM read_parquet('s3://duckdb-md-dataset-121/netflix_daily_top_10.parquet');
FROM netflix;
SHOW netflix;
-- Display the most popular TV Shows
SELECT Title, max("Days In Top 10") from netflix
where Type='TV Show'
GROUP BY Title
ORDER BY max("Days In Top 10") desc
limit 5;
-- Display the most popular TV Shows
SELECT Title, max("Days In Top 10") from netflix
where Type='Movie'
GROUP BY Title
ORDER BY max("Days In Top 10") desc
limit 5;
-- Copy the result to CSV
COPY (
SELECT Title, max("Days In Top 10") from netflix
where Type='TV Show'
GROUP BY Title
ORDER BY max("Days In Top 10") desc
limit 5
) TO 'output.csv' (HEADER, DELIMITER ',');
