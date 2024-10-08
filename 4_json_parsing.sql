-- query directly a json
FROM './data/sales.json' ;

-- accessing struct and array
SELECT
    customer.name AS customer_name,
FROM
    read_json_auto('./data/sales.json');

-- more JSON parsing magic
FROM 'http://extensions.duckdb.org/downloads-last-week.json';

UNPIVOT (FROM 'http://extensions.duckdb.org/downloads-last-week.json')
    ON COLUMNS(* EXCLUDE (_last_update));
