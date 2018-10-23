---
title: 'Creating a binary discrete variable: the Tidy way'
author: Obryan Poyser
date: '2018-07-26'
slug: creating-a-binary-discrete-variable-the-tidy-way
categories:
  - r-Language
tags:
  - factor variable
type: post
description: ""
lang:
  - english
---

```{r, echo=FALSE, message=F, warning=F}
require(janitor)
require(tidyverse)
require(kableExtra)
```


Working with categorical variables in R can be a headache sometimes. Among the things I miss the most in Stata is how easy is to convert categorical variables to dummy/binary variables which are used to compare categorical variables in a regression. For instance, converting the variable result composed by a Likert scale of order 3 (bad, good and excellent). In Stata you just type tabulate result, generate(res) as seen below:

```
tabulate result, generate(res)

          result |      Freq.     Percent        Cum.
 ----------------+-----------------------------------
             bad |          2       40.00       40.00
       excellent |          1       20.00       60.00
            good |          2       40.00      100.00
 ----------------+-----------------------------------
           Total |          5      100.00

```

The result will be:

```
describe

 Contains data
   obs:             5
  vars:             4
  size:           110 (99.9% of memory free)
 ------------------------------------------------------------------------
               storage  display     value
 variable name   type   format      label      variable label
 ------------------------------------------------------------------------
 result          str15  %15s
 res1            byte   %8.0g                  result==bad
 res2            byte   %8.0g                  result==excellent
 res3            byte   %8.0g                  result==good
 ------------------------------------------------------------------------
 Sorted by:
      Note:  dataset has changed since last saved

list

      +--------------------------------+
      |    result   res1   res2   res3 |
      |--------------------------------|
   1. |      good      0      0      1 |
   2. |       bad      1      0      0 |
   3. |      good      0      0      1 |
   4. | excellent      0      1      0 |
   5. |       bad      1      0      0 |
      +--------------------------------+
```

As you can note the are 3 new variables `res1, res2, and res3`. Easy isn’t? Well, in R I haven’t found yet an easy way to emulate the process. Recently I had to “tidy” a survey that I’ve collected on the Internet, in it, some variables were of the type “multiple choice”, particularly every option (category) was identified by a number. Below you can find an example:

```{r}
db <- data.frame(mult_choice1=c("1,2", "2,4,6", "5,6"), age=c(23, 30, 18), education=c("primary", "secondary", "tertiary"))
db %>%
    knitr::kable() %>%
    kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))
```

What I needed was to convert `option=1` to a dummy variable that could be bound to the original data frame. In order to solve this problem I created the code below:

```{r}
tocolF <- function(df, var, sep=",", names=NULL){
    if(!require(tidyverse)){
        install.packages("tidyverse")
        require(tidyverse)
        }
    if(!require(janitor)){
        install.packages("janitor")
        require(janitor)
            }
    varname <- deparse(substitute(var))
    unique <- df %>%
        .[var] %>%
        .[[1]] %>%
        stringr::str_split(pattern = sep) %>%
        unlist() %>%
        unique()
    if(is.null(names)==F){
        lab0 <- names %>%
            as.data.frame() %>%
            tibble::rownames_to_column() %>%
            set_names(c("rowname", "value"))
        lab1 <- unique %>%
            as.tibble() %>%
            left_join(lab0, by="value")
    } else {
        message("Unique categories are going to be used")
    }

    if(is.null(names)==T){
        purrr::map(unique, function(x) {
            stringr::str_detect(string = df[var] %>%
                                    .[[1]], pattern = paste0("(?:^|\\W)", x, "(?:$|\\W)")) %>%
                as.numeric()
        }) %>%
            bind_cols() %>%
            set_names(paste0(varname,"_", unique)) %>%
            janitor::clean_names()
    } else {
        purrr::map(lab1$value, function(x) {
            stringr::str_detect(string = df[var] %>%
                                    .[[1]], pattern = paste0("(?:^|\\W)", x, "(?:$|\\W)")) %>%
                as.numeric()
        }) %>%
            bind_cols() %>%
            set_names(paste0(varname,"_", lab1$rowname)) %>%
            janitor::clean_names()
    }
}
```

The process to convert individual choices to binary variables is done by a _tidy_ form:

```{r, warning=F, message=FALSE}
db %>%
    bind_cols(tocolF(., "mult_choice1")) %>%
    knitr::kable() %>%
    kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))
```

It works also with single category variable such as `education`

```{r, warning=F, message=FALSE}
db %>%
    bind_cols(tocolF(., "education")) %>%
    knitr::kable() %>%
    kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))
```

Voilà! Happy tidying! :D
