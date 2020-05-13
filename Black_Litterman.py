#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 27 12:00:21 2019

@author: sofia
"""
import numpy as np
from pandas_datareader import data
import matplotlib.pyplot as plt
import pandas as pd
import scipy.optimize


#Historical data collection and cleaning   
tickers = ['XOM', 'AAPL', 'MSFT', 'JNJ', 'GE', 'GOOG', 'CVX', 'PG', 'WFC']
#tickers = ['SPY','XLB','XLE','XLF','XLI','XLK','XLP','XLU','XLV','XLY']
start_date = '2010-01-01'
end_date = '2019-11-01'
frequency = 'B' #all weekdays data

def dataCollection(start_date,end_date,frequency):
    stock_data = {}
    all_days = pd.date_range(start=start_date,end = end_date,freq = frequency)
    for t in tickers:
        prices = data.DataReader(t,'yahoo',start_date,end_date)
        adj_close = prices['Adj Close'] #Get the adjusted closing prices
        all_days = pd.date_range(start=start_date,end = end_date,freq = frequency)
        adj_close = adj_close.reindex(all_days) #Reindex adjusted close price using all_weekdays as the new index
        
        #Reindexing will insert missing values (NaN) for the dats that were noe present
        #in the original set. To cope with this, we can fill the missing by replacing them with the 
        #latest available price for each instrument
        adj_close = adj_close.fillna(method='ffill')
        adj_close = adj_close.dropna()
        stock_data[t] = adj_close #Load the desired data

    return (stock_data)

def daily_return(stock_data):
    daily_return = {}
    for t in tickers:
        adj_close = stock_data[t]
        ret = (adj_close - adj_close.shift(1)) / adj_close.shift(1)
        daily_return[t] = ret
    return daily_return

stock_data = dataCollection(start_date,end_date,frequency)
daily_rets =  pd.DataFrame.from_dict(daily_return(stock_data))
hist_rets = daily_rets.mean(axis = 0, skipna = True) * 252
hist_cov = daily_rets.cov() *  252

#Get the market capital
market_cap = data.get_quote_yahoo(tickers)['marketCap']


W = market_cap/sum(market_cap) #Market weights from capitalization
R = hist_rets
C = hist_cov
rf = 0.015

pd.DataFrame({'Return': R, 'Weight(based on market cap)': W},index = tickers).T
C

##############################


def efficient_frontier(R,C,rf):
    def fitness(W,R,C,r):
        #For a given return r, find the weights which minimizes portfolio variance.
        port_mean = sum(R * W)
        port_var = np.dot(np.dot(W,C),W)
        penalty = 100 * abs(port_mean - r)#Big penalty for not meeting stated portfolio return
        return (port_var + penalty)    
    
    frontier_mean = []
    frontier_var = []
    for r in np.linspace(min(R),max(R),num=20):
        W = np.ones([len(R)])/len(R) #start optimization with equal weights
        b_ = [(0, 1) for i in range(len(R))]
        c_ = ({'type': 'eq', 'fun': lambda W: sum(W) - 1.})
        optimized = scipy.optimize.minimize(fitness, W, (R,C,r),method='SLSQP',constraints=c_, bounds=b_)
        if not optimized.success:
            raise BaseException(optimized.message)
        #add point to the efficient frontier [x,y] =  [optimized.x,r]
        frontier_mean.append(r)
        frontier_var.append(np.dot(np.dot(optimized.x,C),optimized.x))
    return [np.array(frontier_mean),np.array(frontier_var)]

#Get risk-free rate, asset returns and covariance
def efficient_weights(R,C,rf):
    def fitness(W,R,C,rf):
        port_mean = sum(R * W)
        port_var = np.dot(np.dot(W,C),W)
        sharp_ratio = (port_mean - rf)/np.sqrt(port_var)
        return 1/sharp_ratio 
    W = np.ones([len(R)]) / len(R)  # start optimization with equal weights
    b_ = [(0., 1.) for i in range(len(R))]  # weights for boundaries between 0%..100%. No leverage, no shorting
    c_ = ({'type': 'eq', 'fun': lambda W: sum(W) - 1.})  # Sum of weights must be 100%
    optimized = scipy.optimize.minimize(fitness, W, (R, C, rf), method='SLSQP', constraints=c_, bounds=b_)
    if not optimized.success: raise BaseException(optimized.message)
    return optimized.x

def optimized_frontier(R,C,rf):
    W = efficient_weights(R,C,rf)
    tangency_mean = sum(R * W)
    tangency_var = np.dot(np.dot(W,C),W)
    frontier_mean = efficient_frontier(R,C,rf)[0]
    frontier_var = efficient_frontier(R,C,rf)[1]
    return ([W,tangency_mean,tangency_var,frontier_mean,frontier_var])

def display_assets(tickers,R,C,color):
    plt.scatter([(np.array(C)[i,i])**0.5 for i in range(len(R))],R,marker = 'x',color = color)
    #for i in range(len(R)): 
        #plt.text((np.array(C)[i,i])**0.5 ** .5, np.array(R)[i], '  %s' % tickers[i], verticalalignment='center', color='black')
        #plt.text((np.array(C)[i,i])**0.5 ** .5, np.array(R)[i], color='black')
    plt.xlim(0, 0.6)

def display_frontier(R,C,rf,label,color):
    tangency_mean = optimized_frontier(R,C,rf)[1]
    tangency_var = optimized_frontier(R,C,rf)[2]
    frontier_mean = optimized_frontier(R,C,rf)[3]
    frontier_var = optimized_frontier(R,C,rf)[4]
    plt.text(tangency_var ** .5, tangency_mean, '    Optimal point', verticalalignment='center', color=color)
    plt.scatter(tangency_var ** .5, tangency_mean, marker='o', color=color)
    plt.plot(frontier_var ** .5, frontier_mean, label = label, color=color) # draw efficient frontier
    
#Mean-Variance Optimization(based on historical returns)
result1 = optimized_frontier(R,C,rf)
#plt.figure(figsize=(10,10))
display_assets(tickers,R,C,'black')
display_frontier(result1[0],result1[1],rf,None,'blue')
plt.xlabel('variance $\sigma$')
plt.ylabel('mean $\mu$')
pd.DataFrame({'Weight': result1[0]}, index=tickers).T




##############################################
###Black Litterman reverse optimization
#Claulate portfolio historical return and variance
port_mean = sum(R * W)
port_var = np.dot(np.dot(W,C),W)
lmb = (port_mean - rf) / port_var
pi = np.dot(np.dot(lmb,C),W)

#Mean-Variance Optimization(based on equilibrium returns)
result2 = optimized_frontier(pi+rf,C,rf)
display_assets(tickers,R,C,'red')
display_frontier(result1[0],result1[1],rf,'Historical returns','red')
display_assets(tickers,pi+rf,C,'blue')
display_frontier(result2[0],result2[1],rf,'Implied returns','blue')
plt.xlabel('variance $\sigma$')
plt.ylabel('mean $\mu$')
plt.legend()
pd.DataFrame({'Weight': result2[0]}, index=tickers).T

#Determine views to the equilibrium returns and prepare views(Q) and link(P) matrices
def create_views_and_link_matrix(tickers,views):
    r = len(views)
    c = len(tickers)
    P = np.zeros([r,c])
    Q = [views[i][3] for i in range(r)]
    nameToIndex = dict()
    for i,n in enumerate(tickers):
        nameToIndex[n] = i+1
    for i,v in enumerate(views):
        name1 = views[i][0]
        name2 = views[i][2]
        if (views[i][1] == ">"):
            P[i,nameToIndex[name1]] = 1 
            P[i,nameToIndex[name2]] = -1
        else:
            P[i,nameToIndex[name1]] = -1
            P[i,nameToIndex[name2]] = 1
    return [np.array(Q), P]
            
views = [('MSFT', '>', 'GE', 0.02),
         ('AAPL', '<', 'JNJ', 0.02)] 
Q = create_views_and_link_matrix(tickers, views)[0]
P = create_views_and_link_matrix(tickers, views)[1]
print('Views Matrix')
pd.DataFrame({'Views':Q})
print('Link Matrix')
pd.DataFrame(P)  

rf=0.15
#Optimization based on Equilibrium returns with adjusted views
tau= 0.025
#Calculate omega - uncertainty matrix about views
omega = np.dot(np.dot(np.dot(tau, P), C),np.transpose(P))
# Calculate equilibrium excess returns with views incorporated
sub_a = np.linalg.inv(np.dot(tau, C))
sub_b = np.dot(np.dot(np.transpose(P), np.linalg.inv(omega)), P)
sub_c = np.dot(np.linalg.inv(np.dot(tau, C)), pi)
sub_d = np.dot(np.dot(np.transpose(P), np.linalg.inv(omega)), Q)
pi_adj = np.dot(np.linalg.inv(sub_a + sub_b), (sub_c + sub_d))

result3 = optimized_frontier(pi + rf, C, rf)

display_assets(tickers, pi+rf, C, color='green')
display_frontier(result2[0],result2[1],rf,label='Implied returns', color='green')
display_assets(tickers, pi_adj+rf, C, color='blue')
display_frontier(result3[0],result3[1],rf,'Implied returns(adjusted views)','blue')
plt.xlabel('variance $\sigma$')
plt.ylabel('mean $\mu$')
plt.legend()
pd.DataFrame({'Weight': result3[0]}, index=tickers).T