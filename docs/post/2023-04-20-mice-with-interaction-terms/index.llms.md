# Multivariate imputation by chained equations (MICE) with interaction terms

Examining how MICE works with interaction terms.

Author

[Richard Aubrey White](https://www.rwhite.no) [![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMC1jMDYwIDYxLjEzNDc3NywgMjAxMC8wMi8xMi0xNzozMjowMCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo1N0NEMjA4MDI1MjA2ODExOTk0QzkzNTEzRjZEQTg1NyIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDozM0NDOEJGNEZGNTcxMUUxODdBOEVCODg2RjdCQ0QwOSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDozM0NDOEJGM0ZGNTcxMUUxODdBOEVCODg2RjdCQ0QwOSIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkZDN0YxMTc0MDcyMDY4MTE5NUZFRDc5MUM2MUUwNEREIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjU3Q0QyMDgwMjUyMDY4MTE5OTRDOTM1MTNGNkRBODU3Ii8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+84NovQAAAR1JREFUeNpiZEADy85ZJgCpeCB2QJM6AMQLo4yOL0AWZETSqACk1gOxAQN+cAGIA4EGPQBxmJA0nwdpjjQ8xqArmczw5tMHXAaALDgP1QMxAGqzAAPxQACqh4ER6uf5MBlkm0X4EGayMfMw/Pr7Bd2gRBZogMFBrv01hisv5jLsv9nLAPIOMnjy8RDDyYctyAbFM2EJbRQw+aAWw/LzVgx7b+cwCHKqMhjJFCBLOzAR6+lXX84xnHjYyqAo5IUizkRCwIENQQckGSDGY4TVgAPEaraQr2a4/24bSuoExcJCfAEJihXkWDj3ZAKy9EJGaEo8T0QSxkjSwORsCAuDQCD+QILmD1A9kECEZgxDaEZhICIzGcIyEyOl2RkgwAAhkmC+eAm0TAAAAABJRU5ErkJggg==)](https://orcid.org/0000-0002-6747-1726)

Published

April 20, 2023

We simulate a dataset where it is not harmful to be male nor a smoker (coefficient = 0), but the interaction of the two is very harmful (coefficient = 5).

We then set the outcome to missing for 70% of the males and 70% of the smokers, and run the following analyses:

- Complete case analysis
- Blindly imputed analysis (using MICE)
- Imputed analysis (using MICE) where males and females were imputed separately.

We repeat this for multiple datasets with various sample sizes, to see how the imputation strategies are affected by the size of the dataset.

``` r
library(data.table)
library(magrittr)
library(ggplot2)

sim_function <- function(data, argset){
  data <- data.table(id = 1:argset$n)
  
  data[, is_male := rbinom(.N, 1, 0.5)]
  data[, is_smoker := rbinom(.N, 1, 0.5)]
  data[, lung_function := -1 + 0 * is_male + 0 * is_smoker + 5 * is_male * is_smoker + rnorm(.N, sd = 2)]
  
  data_missing <- copy(data)
  data_missing[is_male==1 & runif(.N)<0.7, lung_function := NA]
  data_missing[is_smoker==1 & runif(.N)<0.7, lung_function := NA]
  
  # complete case analysis
  coef_complete_case <- coef(summary(lm(lung_function ~ is_male*is_smoker, data = data_missing)))[,1]
  
  # we impute the data blindly
  data_imputed <- mice::mice(data_missing, print=F, m = 20)
  fit_imputed <- with(data_imputed, lm(lung_function ~ is_male*is_smoker))
  coef_imputed_blindly <- mice::pool(fit_imputed)$pooled$estimate
  
  # we impute the data separately for males and females
  data_imputed_male <- mice::mice(data_missing[is_male==1], print=F, m = 20)
  data_imputed_female <- mice::mice(data_missing[is_male==0], print=F, m = 20)
  data_imputed_sex_specific <- mice:::rbind.mids(data_imputed_male, data_imputed_female)
  fit_imputed <- with(data_imputed_sex_specific, lm(lung_function ~ is_male*is_smoker))
  coef_imputed_separately <- mice::pool(fit_imputed)$pooled$estimate
  
  retval <- data.table(
    var = names(coef_complete_case),
    coef_complete_case,
    coef_imputed_blindly,
    coef_imputed_separately,
    n = argset$n
  )
  return(retval)
}

p <- plnr::Plan$new()
for(n in c(100, 500, 1000, 2000, 4000)) for(i in 1:100){
  p$add_argset(
    name = uuid::UUIDgenerate(),
    n=n,
    i=i
  )
}
p$apply_action_fn_to_all_argsets(sim_function)
set.seed(1234)
results <- p$run_all()
results <- rbindlist(results)

results[var == "is_male:is_smoker", .(
  coef_complete_case = round(mean(coef_complete_case), 2),
  coef_imputed_blindly = round(mean(coef_imputed_blindly), 2),
  coef_imputed_separately = round(mean(coef_imputed_separately), 2)
), keyby=.(n)] %>% 
  print()
```

    Key: <n>
           n coef_complete_case coef_imputed_blindly coef_imputed_separately
       <num>              <num>                <num>                   <num>
    1:   100               5.06                 1.33                    2.60
    2:   500               4.97                 3.56                    4.89
    3:  1000               5.10                 4.49                    5.12
    4:  2000               5.03                 4.97                    5.09
    5:  4000               5.05                 5.09                    5.09

We can see that (in this simple example) complete case analysis correctly captured the interaction’s coefficient of 5.

More interesting is that with lower sample sizes, imputing males/females separately performed better than imputing blindly, however, once the sample size became sufficient then there was little difference between the two methods.

The code used to impute the data separately for males and females:

    data_imputed_male <- mice::mice(data_missing[is_male==1], print=F, m = 20)
    data_imputed_female <- mice::mice(data_missing[is_male==0], print=F, m = 20)
    data_imputed_sex_specific <- mice:::rbind.mids(data_imputed_male, data_imputed_female)
