import os

from google.cloud import bigquery


def load_ratings_data(event, context):
    file_data = event
    bucket_name = file_data['bucket']
    file_name = file_data['name']
    table_id = os.environ["TABLE_ID"]

    print(f"New File uploaded: {file_name} in bucket {bucket_name}")

    if not file_name.startswith("rating"):
        print(f"File name is not started with rating. Not meant to be processed here .....")
        return

    print(f"Loading new data from: {file_name} in bigquery table {table_id}")

    client = bigquery.Client()
    schema_list = get_table_schema(client, table_id)
    job_config = get_job_config(schema_list)

    load_job = client.load_table_from_uri(
        f'gs://{bucket_name}/{file_name}', table_id, job_config=job_config
    )

    load_job.result()

    destination_table = client.get_table(table_id)
    print(f"Loaded {destination_table.num_rows} rows in table {table_id}")


def get_table_schema(client, table_id):
    table_schema = client.get_table(table_id)
    schema_list = []
    for field in table_schema.schema:
        if field.name != "load_date":
            schema_list.append(bigquery.SchemaField(name=field.name, field_type=field.field_type, mode=field.mode))
    return schema_list


def get_job_config(schema):
    job_config = bigquery.LoadJobConfig()
    job_config.schema = schema
    job_config.write_disposition = bigquery.WriteDisposition.WRITE_APPEND
    job_config.source_format = bigquery.SourceFormat.CSV
    job_config.skip_leading_rows = 1
    job_config.allow_jagged_rows = True
    return job_config
