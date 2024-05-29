-- query directly a json
FROM './data/sales.json' 

-- accessing struct and array
SELECT
    customer.name AS customer_name,
    items.items.quantity,
    items.items.price,
FROM
    './data/sales.json',
    UNNEST(items) AS items;


-- wrapping up for a sum
WITH orders AS (
    SELECT * FROM read_json_auto('./data/sales.json')
),
exploded AS (
    SELECT
        customer.name AS customer_name,
        items.items.quantity,
        items.items.price,
    FROM
        orders,
        UNNEST(items) AS items
)
SELECT
    customer_name,
    SUM(price * quantity) AS total_spent
FROM
    exploded
GROUP BY
    customer_name;

