---
title: LeetCode 122. Best Time to Buy and Sell Stock II
tags:
  - LeetCode
  - Array
categories:
  - Algorithm
  - LeetCode
abbrlink: 16632
date: 2018-12-11 11:27:56
---

<center>LeetCode 122. Best Time to Buy and Sell Stock II 题解</center>

<!--more-->

##### 题目描述

- **英文：**

Say you have an array for which the *i*th element is the price of a given stock on day *i*.

Design an algorithm to find the maximum profit. You may complete as many transactions as you like (i.e., buy one and sell one share of the stock multiple times).

**Note:** You may not engage in multiple transactions at the same time (i.e., you must sell the stock before you buy again).

- **中文：**

给定一个数组，它的第 *i* 个元素是一支给定股票第 *i* 天的价格。

设计一个算法来计算你所能获取的最大利润。你可以尽可能地完成更多的交易（多次买卖一支股票）。

**注意：**你不能同时参与多笔交易（你必须在再次购买前出售掉之前的股票）。

##### 示例

- **示例 1:**

```
输入: [7,1,5,3,6,4]
输出: 7
解释: 在第 2 天（股票价格 = 1）的时候买入，在第 3 天（股票价格 = 5）的时候卖出, 这笔交易所能获得利润 = 5-1 = 4 。
     随后，在第 4 天（股票价格 = 3）的时候买入，在第 5 天（股票价格 = 6）的时候卖出, 这笔交易所能获得利润 = 6-3 = 3 。
```

- **示例 2:**

```
输入: [1,2,3,4,5]
输出: 4
解释: 在第 1 天（股票价格 = 1）的时候买入，在第 5 天 （股票价格 = 5）的时候卖出, 这笔交易所能获得利润 = 5-1 = 4 。
     注意你不能在第 1 天和第 2 天接连购买股票，之后再将它们卖出。
     因为这样属于同时参与了多笔交易，你必须在再次购买前出售掉之前的股票。
```

- **示例 3:**

```
输入: [7,6,4,3,1]
输出: 0
解释: 在这种情况下, 没有交易完成, 所以最大利润为 0。
```

##### 题解

- **题解 1**

　　分析发现，可以使用取巧的方式来实现，因为这会违反“不能同一天买卖的规则”。假设输入是 [1, 2, 3]，本来应该是第 1 天买入，第 3 天卖出，利润是 3-1 = 2，但是，同时也可以第 1 天买入，第 2 天卖出，第 2 天又买入，第 3 天卖出，利润也是（2-1）+（3-2）= 2。也就是说，只要比较相邻两天的价格，如果当天价格比后一天价格低就买入，然后后一天卖出，得出这一次交易的利润，如果当天价格比后一天价格高，则跳过这一天，最后得出总的利润即可。

```python
class Solution:
    def maxProfit(self, prices):
        """
        :type prices: List[int]
        :rtype: int
        """
        sum = 0
        for i in range(len(prices) - 1):
            if prices[i] >= prices[i + 1]:  # 不交易的情况
                continue
            else:
                sum += prices[i + 1] - prices[i]  # 加上本次交易的利润
        return sum  # 输出总利润
```

- **题解 2**

　　先找到递减的局部最低点（即最佳买入点），再找到递增的局部最高点（最佳卖出点），算一次利润就加起来，保证买卖不会在同一天进行。基本思路就是寻找最佳买入点和卖出点，然后计算利润，再寻找下一次最佳买入点和卖出点，最后得到总的利润之和即可。

```python
class Solution:
    def maxProfit(self, prices):
        """
        :type prices: List[int]
        :rtype: int
        """
        i = 0
        sum = 0
        length = len(prices)
        while i < length - 1:
            while i < length - 1 and prices[i] > prices[i + 1]:  # 寻找局部最佳买入点
                i += 1
            buy = i

            i += 1
            while i < length and prices[i] >= prices[i - 1]:  # 寻找局部最佳卖出点
                i += 1
            sell = i - 1

            sum += prices[sell] - prices[buy]  # 加上每次的利润
        return sum
```

