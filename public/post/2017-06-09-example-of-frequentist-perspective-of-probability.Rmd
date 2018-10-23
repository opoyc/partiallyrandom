---
title: Example of frequentist perspective of probability
author: Obryan Poser
date: '2017-06-09'
slug: example-of-frequentist-perspective-of-probability
categories:
  - Statistics
tags:
  - probability
lang:
  - english
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```


This function tries to visualize the frequentist perspective of probability by flipping an equilibrated *π*(*θ*)=0.5 coin.

Frequentist approach establish that the true probability of an event *θ* is given by:

$$ \pi(\theta_i)=\lim_{\theta_i\to\infty} \frac{n_{\theta\_i}}{n_{trials,i}} $$
\

```{r}
# obs is the number of times a coin is flipped
# coins are the number of indepedent coins tossed at the same time

f.coin=function(flips, coins){
    plot(x = 0
         , ylab = "Probability"
         , xlab = "Times"
         , main = paste("Flipping", coins, "indepedent coins", flips, "times")
         , type = "n", ylim = c(0, 1), xlim = c(0, flips))
    abline(h = .5)
    for(i in 1:coins){
        s1=seq(1, flips)
        s2=cumsum(rbinom(n = flips, size = 1, prob = .5))
        lines(x = s2/s1, type = "l", ylim = c(0,1), col=i)
    }
}

# Testing
par(mfrow=c(2,2))

invisible(lapply(c(10, 100, 1000, 10000), FUN = function(x) f.coin(flips = x, coins = 10)))
```
