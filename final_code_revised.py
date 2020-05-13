#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec 10 11:55:46 2019

@author: sofia
"""

import pandas as pd
import numpy as np
import scipy.stats as scs
import matplotlib.pyplot as plt
from pandas_datareader import data as pdr
import scipy.optimize 
import math

tickers=['EFA','EEM','GLD','IYR']
# tickers=['XOM', 'AAPL', 'MSFT', 'JNJ', 'GE', 'GOOG', 'CVX', 'PG', 'WFC']
start_date = '2007-01-01'
end_date = '2019-11-09'
num=len(tickers)
#old_eta = pd.read_csv('eta.csv')

eta=pd.read_csv('new_eta_NB2.csv')
all_days = pd.date_range(start='2008-1-18',end = '2019-11-02',freq = '7D')
eta['Date']=all_days
label=eta['Date']
date_num=len(label)

def dataCollection(start_date, end_date):
    prices=pdr.get_data_yahoo(tickers,start=start_date,end=end_date)
    adj_close=prices['Adj Close']
    adj_close = adj_close.fillna(method='ffill')
    adj_close = adj_close.dropna()

    return (adj_close)


def daily_return(data):
    daily_return1 = data/data.shift(1)

    return daily_return1

def opt_process(R,C,rf):

    def statistics1(weights,R,C,rf):
        #weights = np.array(weights)
        #a = 1
        port_returns = np.sum(np.dot(R, weights))
        port_variance = np.dot(weights.T, np.dot(C, weights))
        port_a = port_returns - a * port_variance
        #sharp  = (port_returns - rf)/np.sqrt(port_variance)
        
        return 1/port_a
        #return np.array([port_returns, port_variance, port_returns / port_variance, port_a, sharp])

    #def min_aa(weights,R,C,rf):
        #return 1/(statistics1(weights,R,C,rf)[4])
    
    #等权开始优化
    weights = np.ones(len(R))/len(R)
    
    # 约束是所有参数(权重)的总和为1。这可以用minimize函数的约定表达如下
    cons = ({'type': 'eq', 'fun': lambda weights: np.sum(weights) - 1})

    # 我们还将参数值(权重)限制在0和1之间。这些值以多个元组组成的一个元组形式提供给最小化函数
    #bnds = tuple((0, 1) for i in range(num))

    # 优化函数调用中忽略的唯一输入是起始参数列表(对权重的初始猜测)。我们简单的使用平均分布。
    opts1 = scipy.optimize.minimize(statistics1, weights,(R,C,rf), method='SLSQP',constraints = cons)
    #print(opts1)
    if not opts1.success: raise BaseException(opts1.message)
    return opts1.x

def opt_process_mvo(R,C,rf):

    def statistics1(weights,R,C,rf):
        #weights = np.array(weights)
        #a = 1
        port_returns = np.sum(np.dot(R, weights))
        port_variance = np.dot(weights.T, np.dot(C, weights))
        port_a = port_returns - a * port_variance
        sharp  = (port_returns)/(port_variance)
        
        return -sharp
        #return np.array([port_returns, port_variance, port_returns / port_variance, port_a, sharp])

    #def min_aa(weights,R,C,rf):
        #return 1/(statistics1(weights,R,C,rf)[4])
    
    #等权开始优化
    weights = np.ones(len(R))/len(R)
    
    # 约束是所有参数(权重)的总和为1。这可以用minimize函数的约定表达如下
    cons = ({'type': 'eq', 'fun': lambda weights: np.sum(weights) - 1})

    # 我们还将参数值(权重)限制在0和1之间。这些值以多个元组组成的一个元组形式提供给最小化函数
    #bnds = tuple((0, 1) for i in range(num))

    # 优化函数调用中忽略的唯一输入是起始参数列表(对权重的初始猜测)。我们简单的使用平均分布。
    opts1 = scipy.optimize.minimize(statistics1, weights,(R,C,rf), method='SLSQP',constraints = cons)
    #print(opts1)
    if not opts1.success: raise BaseException(opts1.message)
    return opts1.x


#def opt_process(R,C):
#
#    def statistics1(weights,R,C):
#        weights = np.array(weights)
#        a = 1
#        port_returns = np.sum(np.dot(R, weights))
#        port_variance = np.dot(weights.T, np.dot(C, weights))
#        port_a = port_returns - a * port_variance
#
#        return np.array([port_returns, port_variance, port_returns / port_variance, port_a])
#
#    def min_aa(weights,R,C):
#        return -statistics1(weights,R,C)[3]
#
#    # 约束是所有参数(权重)的总和为1。这可以用minimize函数的约定表达如下
#    cons = ({'type': 'eq', 'fun': lambda x: np.sum(x) - 1})
#
#    # 我们还将参数值(权重)限制在0和1之间。这些值以多个元组组成的一个元组形式提供给最小化函数
#    bnds = tuple((0, 1) for x in range(num))
#
#    # 优化函数调用中忽略的唯一输入是起始参数列表(对权重的初始猜测)。我们简单的使用平均分布。
#    opts1 = scipy.optimize.minimize(min_aa, num * [1. / num, ],(R,C), method='SLSQP',constraints = cons,bounds = bnds)
#    if not opts1.success: raise BaseException(opts1.message)
#    print(opts1)
#
#    return opts1.x

#Determine views to the equilibrium returns and prepare views(Q) and link(P) matrices
adj_price = dataCollection(start_date,end_date)
adj_price1 = adj_price.reset_index()
log_return=daily_return(adj_price).fillna(1)
log_return=log_return.applymap(lambda x: math.log(x))
log_return1 = log_return.reset_index()
market_cap = pdr.get_quote_yahoo(tickers)['marketCap']
W = market_cap/sum(market_cap) #Market weights from capitalization

#Risk-free rate
tb = pdr.get_data_yahoo('^IRX',start=start_date,end=end_date)
tb = tb['Adj Close']/100
tb=tb.reset_index()
# rf = np.mean(tb)
#tb = tb.fillna(method='ffill')
#tb = tb.dropna()
#tb1 = tb.reset_index()
#rf = daily_rf*252
#rf = daily_return(tb).fillna(1)
#rf = np.log(rf)
#rf1 = rf.reset_index()
#rf1.mean()

weight_list=[]
weight_mvo = []
i=label[0]
a = log_return1[log_return1['Date'] == i.strftime('%Y-%m-%d')].index.tolist()
a=a[0]
j=0
for i in label:
    eta_use=eta.loc[j]
    j=j+1
    a = log_return1[log_return1['Date'] == i.strftime('%Y-%m-%d')].index.tolist()
    if a==[]:
        a=b+4
    else:
        a=a[0]

    b = a



    c=a-150
    log_return_use=log_return1.loc[c:a]
    rf_use = tb.loc[c:a]
    return_mean = log_return_use.mean() * 252
    return_cov = log_return_use.cov() * 252




    R = return_mean
    C = return_cov
    rf = rf_use.mean()[0]
    #print (rf)
    Er=np.dot(W,R)
    port_variance = np.dot(W.T, np.dot(C, W))
    risk_aversion=(Er-rf)/port_variance

    pi=risk_aversion*np.dot(C,W)
    P = np.eye(4)
    PP=np.dot(np.dot(P,C),P.T)

    Q=[]
    for i in range(num):
        Q1 =np.dot(P,pi)[i]+eta_use[i+1]*np.sqrt(PP[i][i])
        Q.append(Q1)

    Q=np.array(Q)

    num=len(Q)
    tau=0.25
    omega1=[]



    for i in range(num):
        omega1.append(np.dot(np.dot(P[i],C),P[i].T)*tau)

    omega1=np.array(omega1)
    omega=np.diag(omega1)
    omega_inv=np.linalg.inv(omega)

    # AA=np.linalg.inv(np.dot(tau,C))
    # BB=np.dot(np.dot(P.T,omega_inv),P)
    # CC=np.dot(np.linalg.inv(np.dot(tau,C)),pi)
    # DD=np.dot(np.dot(P.T,omega_inv),Q)
    #
    # ER=np.dot(np.linalg.inv(AA+BB),CC+DD)

    AA=tau*np.dot(C,P.T)
    BB=np.linalg.inv(np.dot(np.dot(P,C),P.T)*tau+omega)
    CC=Q-np.dot(P,pi)

    ER=pi+np.dot(np.dot(AA,BB),CC)
    
    
    AAA = (1+tau)*C
    BBB = (tau**2)*np.dot(C,P.T)
    CCC = np.linalg.inv(tau*np.dot(np.dot(P,C),P.T))
    DDD = np.dot(P,C)
    C_bl = AAA + np.dot(np.dot(BBB,CCC),DDD)

    #weight=np.dot(np.linalg.inv(np.dot(risk_aversion,C)),ER)
    weight = opt_process(ER,C_bl,rf)
    weight = weight/sum(weight)
    weight_list.append(weight)
    
    weight_m= opt_process_mvo(R,C,rf)
    weight_m = weight_m/sum(weight_m)
    weight_mvo.append(weight_m)
    

df= pd.DataFrame(weight_list,index=label,columns=tickers)
df.to_csv('weight_NB2.csv')

df_m= pd.DataFrame(weight_mvo,index=label,columns=tickers)
df_m.to_csv('weight_mvo_NB2.csv')