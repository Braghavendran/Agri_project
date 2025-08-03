import pandas as pd
data_path = "C:\AgriDataExplorer\Data\ICRISAT-District Level Data - ICRISAT-District Level Data.csv"
df = pd.read_csv(data_path)
print("First 5 rows of dataset:")
print(df.head())
print("\nMissing Values Summary:")
print(df.isnull().sum())
duplicates = df.duplicated().sum()
print(f"\nNumber of duplicate rows: {duplicates}")
df.columns = df.columns.str.strip().str.lower().str.replace(" ", "_").str.replace("(", "").str.replace(")", "")
cleaned_path = "cleaned_agriculture_data.csv"
df.to_csv(cleaned_path, index=False)
print(f"\nCleaned dataset saved to: {cleaned_path}")