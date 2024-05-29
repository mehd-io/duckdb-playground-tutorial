-- Enter the CLI again and try the following
-- view extensions 
SELECT * FROM duckdb_extensions();
-- Install extension
INSTALL httpfs;
-- Load extension
LOAD httpfs;
-- Check again state of extension
SELECT * FROM duckdb_extensions();
