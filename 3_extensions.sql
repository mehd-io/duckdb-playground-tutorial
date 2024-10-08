-- Enter the CLI again and try the following
-- view extensions 
FROM duckdb_extensions();
-- Install extension
INSTALL httpfs;
-- Load extension
LOAD httpfs;
-- Community extension
INSTALL scrooge FROM community;
LOAD scrooge;

select * FROM yahoo_finance(["^GSPC","BTC-USD"], "2017-12-01", "2017-12-10", "1d");
