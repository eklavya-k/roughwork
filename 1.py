import pandas as pd

parquet_file_path = '/Users/eklavyakumar/Documents/roughwork/part-00000-cb76bcdb-529c-4e3d-970f-b98502f8b4d5.c000.snappy.parquet'
json_file_path = 'result.json'


df = pd.read_parquet(parquet_file_path)
df.to_json(json_file_path, orient='records', lines=True)

print(f"Data successfully written to {json_file_path}")