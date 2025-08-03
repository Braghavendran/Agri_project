import pandas as pd
from sqlalchemy import create_engine

# Load cleaned dataset
df = pd.read_csv("C:\AgriDataExplorer\Data\cleaned_agriculture_data.csv")

# Database connection details
username = "postgres"
password = "1234"
host = "localhost"
port = "5432"  # default PostgreSQL port
database = "agriculture_data"

# Create SQLAlchemy engine
engine = create_engine(f"postgresql+psycopg2://{username}:{password}@{host}:{port}/{database}")

# Write dataframe to PostgreSQL table
table_name = "agriculture_stats"
df.to_sql(table_name, engine, if_exists='replace', index=False)

print(f"✅ Data successfully loaded into PostgreSQL table: {table_name}")