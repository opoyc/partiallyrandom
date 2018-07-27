---
title: Save with time stamp
author: Obryan Poser
date: '2017-04-26'
slug: save-with-time-stamp
categories:
  - R-Language
tags:
  - Time stamp
  - writecsv
# year: '2017'
lang:
  - english
---

Oftenly I have to deal with modifications of a scraping code, whose outcomes change or are subject to errors. Hence, I found useful to have a way to create versions of a data frame, this is a made `savts`.

This simple yet useful function creates csv file with time stamp. It saves a data frame in the working directory as a csv file, separated by semicolon with a date and system time (format `%d%m%y_%H%M`).

```
savts = function(x) {
  write.csv2(x, paste(getwd(), "/", deparse(substitute(x)), "-", format(Sys.time(),
    "%d%m%y_%H%M"), ".csv", sep = ""), row.names = FALSE)
}
```
