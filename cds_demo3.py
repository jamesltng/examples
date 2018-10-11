import pandas as pd
get_ipython().magic(u'matplotlib inline')
import matplotlib.pyplot as plt
import numpy as np
import statsmodels.formula.api as sm
import os

# get current directory
os.getcwd()

# set working directory
os.chdir('/Users/jng2/Dropbox/Work/python_stuff')

dfauto = pd.read_csv('auto.csv')

dfauto.columns.values

dfauto.dtypes

dfauto.head()

dfauto.describe()

dfauto.describe().transpose()

# split make into two parts, store in new columns
dfauto['automaker'] = dfauto['make'].str.split().str[0]

dfauto['model'] = dfauto['make'].str.split().str[1]

dfauto['automaker'].unique()

# compute averages by automaker
aveprice = dfauto['price'].groupby(dfauto['automaker']).mean()


aveprice.name = 'aveprice'


avempg = dfauto['mpg'].groupby(dfauto['automaker']).mean() 
avempg.name = 'avempg'

# store as new dataframe
dfmeans = pd.concat([aveprice,avempg],axis=1)


dfmeans['automaker']=dfmeans.index

# scatter plot of ave price vs ave mpg
dfmeans.plot(x='aveprice', y='avempg', kind='scatter')



# create scatter with labeled points, save as png
fig, ax = plt.subplots()
ax.scatter(dfmeans['aveprice'], dfmeans['avempg'])
for i, row in dfmeans.iterrows():
    ax.annotate(row['automaker'], xy=(row['aveprice'], row['avempg']))
plt.savefig('scatterplot.png')

# back to original data

dfauto['foreign'].value_counts()

origin = dfauto['foreign'].value_counts()

origin.plot(kind='bar')

dfauto['goodmpg'] = dfauto['mpg']>=30

# cross-tabulate origin and goodmpg
pd.crosstab(dfauto['foreign'], dfauto['goodmpg'])

# idenfify vehicles with good mpg
dfauto.loc[dfauto['goodmpg']==True]


# determinants of price
model = sm.ols(formula="price ~ mpg + headroom + trunk + weight + length + foreign", data=dfauto).fit()

print(model.summary())


# reshaping wide to long
df_bpwide = pd.read_csv('bpwide.csv')

df1 = pd.wide_to_long(df_bpwide, 'bp', i='patient', j='when', sep='_', suffix='.')

df1 = df1.reset_index()

# long to wide
w = df1.set_index(['patient','when']).unstack()
w.columns = pd.Index(w.columns).str.join('')
w = w.reset_index()


# merging two datasets

dfhappy = pd.read_csv('happy_annual.csv')
dfgdp = pd.read_csv('gdp_annual.csv')
df_happy_gdp = pd.merge(dfhappy, dfgdp)

# plot gdp and happiness over time (two y axes)
fig, ax1 = plt.subplots()
line1 = ax1.plot(df_happy_gdp['year'], df_happy_gdp['happy'])
ax2 = ax1.twinx()
line2 = ax2.plot(df_happy_gdp['year'], df_happy_gdp['gdppc'], linestyle='dashed', color='green')

# add legend
line1, label1 = ax1.get_legend_handles_labels()
line2, label2 = ax2.get_legend_handles_labels()
ax2.legend(line1 + line2, label1 + label2)
