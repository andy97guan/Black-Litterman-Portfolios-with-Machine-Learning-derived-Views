import pandas as pd
import numpy as np
import scipy.stats as scs
import matplotlib.pyplot as plt
from pandas_datareader import data as pdr
import scipy.optimize as sco


stock_set=['EEM','EFA','TLT','GLD']
num=len(stock_set)
data=pdr.get_data_yahoo(stock_set,start='2004-12-01',end='2018-06-30')   # For data
data_close=data['Close']



log_return=np.log(data_close/data_close.shift(1))
cumulatives_log_return=np.log(data_close/data_close.ix[0])
cumulatives_log_return.plot(linewidth=0.5)
plt.legend(loc=3)
plt.title('cumulatives log return')
plt.savefig('fix.jpg',dpi=300)
plt.show()
return_mean=log_return.mean()
return_cov=log_return.cov()*252


























