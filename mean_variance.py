# -*- coding: utf-8 -*-
"""
Created on Wed Oct 23 13:02:39 2019

@author: guan0
"""

import pandas as pd
import numpy as np
import scipy.stats as scs 
import matplotlib.pyplot as plt
from pandas_datareader import data as pdr
import scipy.optimize as sco


stock_set=['EEM','EFA','TLT','GLD','IYR']
num=len(stock_set)
data=pdr.get_data_yahoo(stock_set,start='2018-01-01',end='2018-12-31')   # For data
data_close=data['Close']


# 规范化后时序数据
data1=data_close/data_close.ix[0]*100
data1.plot()
plt.legend(loc=3)
plt.show()


# log return

log_return=np.log(data_close/data_close.shift(1))

return_mean=log_return.mean()

return_cov=log_return.cov()*252


#分配初始权重

weights = np.random.random(num)
weights = weights/np.sum(weights)


# 预期收益
expect_return=np.sum(return_mean*weights)*252
# 预期方差
expect_var1=np.dot(weights.T, np.dot(return_cov,weights))




# 蒙塔卡罗
port_returns = []
port_variance = []
for p in range(10000):
    weights = np.random.random(num)
    weights /=np.sum(weights)
    port_returns.append(np.sum(log_return.mean()*252*weights))
    port_variance.append(np.sqrt(np.dot(weights.T, np.dot(log_return.cov()*252, weights))))





port_returns = np.array(port_returns)
port_variance = np.array(port_variance)

#无风险利率设定为4%
risk_free = 0.04
plt.figure(figsize = (8,4))
plt.scatter(port_variance, port_returns, c=(port_returns-risk_free)/port_variance, marker = 'o')
plt.grid(True)
plt.xlabel('excepted volatility')
plt.ylabel('expected return')
plt.colorbar(label = 'Sharpe ratio')





# 建立statistics函数来记录重要的投资组合统计数据（收益，方差和夏普比） 通过对约束最优问题的求解，得到最优解。其中约束是权重总和为1。

def statistics(weights):
    weights = np.array(weights)
    port_returns = np.sum(log_return.mean()*weights)*252
    port_variance = np.sqrt(np.dot(weights.T, np.dot(log_return.cov()*252,weights)))

    return np.array([port_returns, port_variance, port_returns/port_variance])

#最优化投资组合的推导是一个约束最优化问题


# 最小化函数minimize很通用，考虑了参数的（不）等式约束和参数的范围。
# 我们从夏普指数的最大化开始。 正式地说，最小化夏普指数的负值：

def min_sharpe(weights):

    return -statistics(weights)[2]

#约束是所有参数(权重)的总和为1。这可以用minimize函数的约定表达如下
cons = ({'type':'eq', 'fun':lambda x: np.sum(x)-1})

#我们还将参数值(权重)限制在0和1之间。这些值以多个元组组成的一个元组形式提供给最小化函数
bnds = tuple((0,1) for x in range(num))

#优化函数调用中忽略的唯一输入是起始参数列表(对权重的初始猜测)。我们简单的使用平均分布。
opts = sco.minimize(min_sharpe, num*[1./num,], method = 'SLSQP', bounds = bnds, constraints = cons)
print(opts)




# 接下来， 我们最小化投资组合的方差。
# 这与被动率的最小化相同，我们定义一个函数对方差进行最小化：
def min_func_variance(weights):
    return statistics(weights)[1]**2

optv = sco.minimize(min_func_variance, num * [1. / num, ], method='SLSQP', bounds=bnds, constraints=cons)

print(optv)











# 组合有效前沿

def min_variance(weights):

    return statistics(weights)[1]

#在不同目标收益率水平（target_returns）循环时，最小化的一个约束条件会变化。

target_returns = np.linspace(-0.2,0,50)
target_variance = []

for tar in target_returns:
    cons = ({'type':'eq','fun':lambda x:statistics(x)[0]-tar},{'type':'eq','fun':lambda x:np.sum(x)-1})
    res = sco.minimize(min_variance, num*[1./num,],method = 'SLSQP', bounds = bnds, constraints = cons)
    target_variance.append(res['fun'])

target_variance = np.array(target_variance)


#画图


plt.figure(figsize = (8,4))
#圆圈：蒙特卡洛随机产生的组合分布
plt.scatter(port_variance, port_returns, c = port_returns/port_variance,marker = 'o')
#叉号：有效前沿
plt.scatter(target_variance,target_returns, c = target_returns/target_variance, marker = 'x')
#红星：标记最高sharpe组合
plt.plot(statistics(opts['x'])[1], statistics(opts['x'])[0], 'r*', markersize = 15.0)
#黄星：标记最小方差组合
plt.plot(statistics(optv['x'])[1], statistics(optv['x'])[0], 'y*', markersize = 15.0)
plt.grid(True)
plt.xlabel('expected volatility')
plt.ylabel('expected return')
plt.colorbar(label = 'Sharpe ratio')
plt.show()

























