from google.cloud import bigquery

sql_file = "./files/github_sample.sql"
table_id = "ca-kitano-study-sandbox.github_source_data.git_sample"

client = bigquery.Client()
job_config = bigquery.QueryJobConfig(destination=table_id)

with open(sql_file) as f:
    sql = f.read()

job=client.query(sql,job_config=job_config,location="US")
job.result()



