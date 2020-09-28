from google.cloud import bigquery
import os

pj_name = os.environ["GCP_PROJECT"]
sql_file = "./files/github_sample.sql"
table_id = pj_name + ".github_source_data.git_sample"

client = bigquery.Client()
job_config = bigquery.QueryJobConfig(destination=table_id)

with open(sql_file) as f:
    sql = f.read()

job=client.query(sql,job_config=job_config,location="US")
job.result()



