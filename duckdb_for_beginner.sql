

-- Run your first query
SELECT 'mandarin' as duck;

-- Query public bucket on a Parquet file
FROM read_parquet('s3://us-prd-motherduck-open-datasets/hacker_news/parquet/hacker_news_2021_2022.parquet') limit 5;

-- Display install/loaded extensions
FROM duckdb_extensions();

-- Install extensions manually
INSTALL spatial;
LOAD spatial;

-- Create a DuckDB tables based on a SELECT query
CREATE TABLE hacker_news_sample AS SELECT * FROM 's3://us-prd-motherduck-open-datasets/hacker_news/parquet/hacker_news_2021_2022.parquet' limit 5;

SHOW ALL TABLES;

-- Use FROM first statement to directly query a table
FROM hacker_news_sample;

-- Persist data by creating or attaching if exists a database
ATTACH 'my_hacker_news_stats.ddb';
USE my_hacker_news_stats;

-- Create a larger table (10GB) in DuckDB
CREATE TABLE hacker_news_full AS SELECT * FROM 's3://us-prd-motherduck-open-datasets/hacker_news/parquet/hacker_news_2016_2025.zstd.parquet';

-- Display count
SELECT COUNT(*) from hacker_news_full;

-- Display timer on query
.timer on

ATTACH 'hacker_news_stats';

-- Compute the top domains shared
CREATE TABLE hacker_news_stats.top_domains as (SELECT
    regexp_extract(url, 'http[s]?://([^/]+)/', 1) AS domain,
    count(*) AS count
FROM hacker_news_full
WHERE url IS NOT NULL AND regexp_extract(url, 'http[s]?://([^/]+)/', 1) != ''
GROUP BY domain
ORDER BY count DESC
LIMIT 20
);

-- Compute the mentions of DuckDB per month
CREATE TABLE hacker_news_stats.duckdb_mentions AS (
SELECT
    YEAR(timestamp) AS year,
    MONTH(timestamp) AS month,
    COUNT(*) AS keyword_mentions
FROM hacker_news_full 
WHERE
    (title LIKE '%duckdb%' OR text LIKE '%duckdb%')
GROUP BY year, month
ORDER BY year ASC, month ASC);

-- Export data to CSV using the COPY command
COPY (SELECT * FROM hacker_news_stats.top_domains) TO 'top_domains.csv'


-- Create AWS secret based on sso chain (assuming you did `aws sso login before`)
CREATE PERSISTENT SECRET aws_secret (
    TYPE S3,
    PROVIDER CREDENTIAL_CHAIN
);

-- Display which secrets has been created
FROM duckdb_secrets();


ATTACH 'hacker_news_stats.db';

SHOW ALL TABLES;
SHOW DATABASES;

-- Connecting to MotherDuck
ATTACH 'md:';


-- Showing the query planner, explaining where things are being run (local/remote)
EXPLAIN SELECT
    regexp_extract(url, 'http[s]?://([^/]+)/', 1) AS domain,
    count(*) AS count
FROM sample_data.hn.hacker_news
WHERE url IS NOT NULL AND regexp_extract(url, 'http[s]?://([^/]+)/', 1) != ''
GROUP BY domain
ORDER BY count DESC
LIMIT 20;

-- Create a Cloud database
CREATE DATABASE cloud_hacker_news_stats;

-- Move a local DuckDB table to MotherDuck
CREATE TABLE cloud_hacker_news_stats.top_domains AS SELECT * FROM hacker_news_stats.top_domains;

-- Create a database share
CREATE SHARE my_share FROM cloud_hacker_news_stats;

-- Create a secret in MotherDuck
CREATE SECRET aws_secret IN MOTHERDUCK (
    TYPE S3,
    PROVIDER CREDENTIAL_CHAIN
);

.timer on 
SELECT
    regexp_extract(url, 'http[s]?://([^/]+)/', 1) AS domain,
    count(*) AS count
FROM 's3://us-prd-motherduck-open-datasets/hacker_news/parquet/hacker_news_2016_2025.zstd.parquet'
WHERE url IS NOT NULL AND regexp_extract(url, 'http[s]?://([^/]+)/', 1) != ''
GROUP BY domain
ORDER BY count DESC
LIMIT 20;

ATTACH 'md:';
