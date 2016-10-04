import pandas
# import dplython functions
from dplython import (DplyFrame, X, diamonds, select, sift, sample_frac, sample_n, head, arrange,mutate, group_by,summarize)

# generate some data
data = {'name': ['Jason', 'Molly', np.nan, 'Jake', 'Amy'], 
        'year': [2012, 2012, 2013, 2014, 2014], 
        'reports': [4, 24, 31, 2, 3],
        'coverage': [25, 94, 57, 62, 70]}
# create pandas dataframe with row names
df = pd.DataFrame(data, index = ['Cochice', 'Pima', 'Santa Cruz', 'Maricopa', 'Yuma'])
row = df[:3]
two_cols = df[["year", "reports"]]
two_cols_index = df.ix[:, 0:3]      # .ix allows to subset column

# df.iloc[:3, 0:3]      # .iloc allows to subset column , .iloc[row,column]

# create dplython data frame
# diamonds = DplyFrame(pandas.read_csv('./diamonds.csv'))
ds = DplyFrame(data)

# select function
# 
ds_select = ds >> select(X.name, X.year) >> head(2)

# filter function (wrap pipes with `()`)
ds_filter = (diamonds >>
    sift(X.carat > 4) >>
    select(X.carat, X.cut, X.price))
    
ds_filter2 = diamonds >> sift((X.carat > 4) | (X.cut == "Ideal")) >> head(2)

# arrange function
ds_arrange = (diamonds >> 
  sample_n(10) >> 
  arrange(X.carat) >> 
  select(X.carat, X.cut, X.depth, X.price))

# mutate and group by function
ds_group_by = (diamonds >> 
  mutate(carat_bin=X.carat.round()) >> 
  group_by(X.cut, X.carat_bin) >> 
  summarize(avg_price=X.price.mean()))
  
# create new column
diamonds["column w/ spaces"] = range(len(diamonds))
ds_new_column = diamonds >> select(X["column w/ spaces"]) >> head()

import dplython
# only importing dplython
func_not_import = (dplython.diamonds >> 
                        dplython.select(dplython.X.carat,dplython.X.cut, dplython.X.price) >>
                        dplython.head(5))
