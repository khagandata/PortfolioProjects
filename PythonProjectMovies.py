#!/usr/bin/env python
# coding: utf-8

# In[11]:


import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import matplotlib
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8)

df = pd.read_csv(r'C:\Users\khaga\Downloads\Data Analyst Portfolio Projects\movies.csv')


# In[12]:


df.head()


# In[16]:


for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%' .format(col, pct_missing))


# In[17]:


df = df.dropna(how='any',axis=0) 


# In[18]:


#data types
df.dtypes


# In[19]:


#change data types

df['budget'] = df['budget'].astype('int64')
df['votes'] = df['votes'].astype('int64')
df['gross'] = df['gross'].astype('int64')
df['runtime'] = df['runtime'].astype('int64')


# In[48]:


df.head()


# In[21]:


#correct year column creation
df['yearcorrect'] = df['released'].astype(str).str.split(', ').str[-1].astype(str).str[:4]


# In[47]:


df.head()


# In[27]:


df = df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[24]:


pd.set_option('display.max_rows', None)


# In[25]:


#duplicate check and drop

df['company'].drop_duplicates().sort_values(ascending=False)


# In[30]:


#scatter plot, budget vs gross

plt.scatter(x=df['budget'], y=df['gross'])

plt.title('Budget vs Gross Earnings')
plt.xlabel('Budget for Film')
plt.ylabel('Gross Earnings')

plt.show()


# In[28]:


df.head()


# In[32]:


#plot budget vs gross using seaborn

sns.regplot(x='budget', y='gross', data=df, scatter_kws={"color":"red"}, line_kws={"color":"blue"})


# In[33]:


#correlation, pearson, kendall, spearman, correlation matrix
df.corr(method='pearson')


# In[37]:


correlation_matrix = df.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matrix for Numeric Features')
plt.xlabel('Movie Features')
plt.ylabel('Movie Features')

plt.show()


# In[38]:


df_numerized = df

for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes


# In[49]:


df_numerized.head()


# In[40]:


correlation_matrix = df_numerized.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matrix for Numeric Features')
plt.xlabel('Movie Features')
plt.ylabel('Movie Features')

plt.show()


# In[41]:


df_numerized.corr()


# In[42]:


correlation_mat = df_numerized.corr()
corr_pairs = correlation_mat.unstack()

corr_pairs


# In[43]:


sorted_pairs = corr_pairs.sort_values()

sorted_pairs


# In[45]:


high_corr = sorted_pairs[(sorted_pairs) > 0.5]

high_corr


# In[ ]:




