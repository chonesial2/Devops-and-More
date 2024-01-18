# read csv with a column as index
import pandas as pd
df = pd.read_csv('Iris.csv', usecols=['SepalLengthCm', 'SepalWidthCm', 'PetalLengthCm', 'PetalWidthCm', 'Species'])
print(df.head())
