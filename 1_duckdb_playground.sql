-- create a table
CREATE TABLE ducks AS

SELECT
    3 AS age,
    'mandarin' AS breed;

-- display tables
SHOW tables;

-- select * from ducks
FROM ducks;

-- show databases
show databases;

-- understanding DuckDB file format
duckdb my_db.ddb 

SELECT *
FROM
    read_csv_auto('./data/netflix_daily_top_10.csv')
limit
    3;

-- exit and reuse 'attach'
duckdb
ATTACH 'my_db.ddb';

SHOW tables;

-- create a table from csv and infer schema
CREATE TABLE netflix_daily_top_10 AS
FROM read_csv_auto('./data/netflix_daily_top_10.csv');

SHOW tables;

-- export to csv
COPY netflix_daily_top_10 TO 'output.csv' (HEADER, DELIMITER ',');

-- export to parquet
COPY netflix_daily_top_10 TO 'output.parquet' (FORMAT PARQUET);

-- Changing display of data and ouput mode
.mode -- useful when dealing with JSON for instance
.mode line
FROM netflix_daily_top_10;

SELECT
    *
FROM
    './data/sales.json';

-- output result to a markdown file
.mode markdown.output myfile.md
FROM netflix_daily_top_10;

-- Quit the CLI and try the following
-- Using the CLI to run a command and exit the process
duckdb - c "SELECT * FROM read_parquet('./data/netflix_daily_top_10.parquet');"
