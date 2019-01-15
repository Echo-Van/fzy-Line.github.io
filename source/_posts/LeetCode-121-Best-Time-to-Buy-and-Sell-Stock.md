---
title: LeetCode 121. Best Time to Buy and Sell Stock
tags:
  - LeetCode
  - Array
categories:
  - Algorithm
  - LeetCode
abbrlink: 40852
date: 2018-12-10 23:27:59
---

<center>LeetCode 121. Best Time to Buy and Sell Stock 题解</center>

<!--more-->

##### 题目描述

- **英文：** 

Say you have an array for which the *i*th element is the price of a given stock on day *i*.

If you were only permitted to complete at most one transaction (i.e., buy one and sell one share of the stock), design an algorithm to find the maximum profit.

Note that you cannot sell a stock before you buy one.

- **中文：** 

给定一个数组，它的第 *i* 个元素是一支给定股票第 *i* 天的价格。

如果你最多只允许完成一笔交易（即买入和卖出一支股票），设计一个算法来计算你所能获取的最大利润。

注意你不能在买入股票前卖出股票。

##### 示例

- **示例 1:**

```
输入: [7,1,5,3,6,4]
输出: 5
解释: 在第 2 天（股票价格 = 1）的时候买入，在第 5 天（股票价格 = 6）的时候卖出，最大利润 = 6-1 = 5 。
注意利润不能是 7-1 = 6, 因为卖出价格需要大于买入价格。
```

- **示例 2:**

```
输入: [7,6,4,3,1]
输出: 0
解释: 在这种情况下, 没有交易完成, 所以最大利润为 0。
```

##### 题解

- **题解 1**

　　常规思路：两层循环，第一层循环遍历价格数组（最后一个元素除外），第二层循环用于比较当前价格与其后的价格，如果大于当前价格则检查差值是否大于暂存的利润，如果是，则替换掉暂存的利润。最后，输出暂存的利润即为最大的利润。但是，提交后提示**超时**。

```python
class Solution:
    def maxProfit(self, prices):
        """
        :type prices: List[int]
        :rtype: int
        """
        length = len(prices)
        res = 0
        for i in range(length-1):
            for j in range(i+1, length):
                if prices[i] < prices[j]:
                    tmp = prices[j] - prices[i]
                    if res < tmp:
                        res = tmp
        return res
```

- **题解 2**

　　使用一层循环，保证两点：（1）始终保存最小的买入价格。（2）始终保存最大的利润。这其中暗含的逻辑是，后面的数如果减 1 的差肯定比减 2 的差大。

```python
class Solution:
    def maxProfit(self, prices):
        """
        :type prices: List[int]
        :rtype: int
        """
        maxProfit, minPrice = prices[0], 0
        for i in range(len(prices)):  # 遍历价格数组
            minPrice = min(minPrice, prices[i])  # 保存最小的买入价格
            maxProfit = max(maxProfit, prices[i] - minPrice)  # 保存最大的利润
        return maxProfit
```



