
-- private file
FROM 's3://tmp-mehdio/pypi_file_downloads.parquet' limit 5;

-- secrets through SSO, support for AWS, GCP, Azure, and more
CREATE SECRET (
      TYPE S3,
      PROVIDER CREDENTIAL_CHAIN
  );

-- https://duckdb.org/docs/configuration/secrets_manager.html
