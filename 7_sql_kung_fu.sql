WITH nested AS (
  SELECT
    author.*,
    UNNEST(weeks) AS weeks_struct
  FROM
    read_json('https://api.github.com/repos/duckdb/duckdb/stats/contributors')
)
SELECT
  login,
  bar(SUM(weeks_struct.c),0,1500,30) AS chart,
  SUM(weeks_struct.c) AS total_commits
FROM
  nested
GROUP BY
  login
ORDER BY
  total_commits DESC
LIMIT 15;
