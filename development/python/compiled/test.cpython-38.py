# uncompyle6 version 3.8.0
# Python bytecode 3.8.0 (3413)
# Decompiled from: Python 3.8.10 (default, Nov 26 2021, 20:14:08) 
# [GCC 9.3.0]
# Embedded file name: test.py
# Compiled at: 2022-03-11 12:43:05
# Size of source mod 2**32: 187 bytes
import pandas as pd
df = pd.read_csv('Iris.csv', usecols=['SepalLengthCm', 'SepalWidthCm', 'PetalLengthCm', 'PetalWidthCm', 'Species'])
print(df.head())