# Sampling bias

Examining sampling bias in simulated data.

Author

[Richard Aubrey White](https://www.rwhite.no) [![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMC1jMDYwIDYxLjEzNDc3NywgMjAxMC8wMi8xMi0xNzozMjowMCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo1N0NEMjA4MDI1MjA2ODExOTk0QzkzNTEzRjZEQTg1NyIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDozM0NDOEJGNEZGNTcxMUUxODdBOEVCODg2RjdCQ0QwOSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDozM0NDOEJGM0ZGNTcxMUUxODdBOEVCODg2RjdCQ0QwOSIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkZDN0YxMTc0MDcyMDY4MTE5NUZFRDc5MUM2MUUwNEREIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjU3Q0QyMDgwMjUyMDY4MTE5OTRDOTM1MTNGNkRBODU3Ii8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+84NovQAAAR1JREFUeNpiZEADy85ZJgCpeCB2QJM6AMQLo4yOL0AWZETSqACk1gOxAQN+cAGIA4EGPQBxmJA0nwdpjjQ8xqArmczw5tMHXAaALDgP1QMxAGqzAAPxQACqh4ER6uf5MBlkm0X4EGayMfMw/Pr7Bd2gRBZogMFBrv01hisv5jLsv9nLAPIOMnjy8RDDyYctyAbFM2EJbRQw+aAWw/LzVgx7b+cwCHKqMhjJFCBLOzAR6+lXX84xnHjYyqAo5IUizkRCwIENQQckGSDGY4TVgAPEaraQr2a4/24bSuoExcJCfAEJihXkWDj3ZAKy9EJGaEo8T0QSxkjSwORsCAuDQCD+QILmD1A9kECEZgxDaEZhICIzGcIyEyOl2RkgwAAhkmC+eAm0TAAAAABJRU5ErkJggg==)](https://orcid.org/0000-0002-6747-1726)

Published

February 23, 2023

``` r
library(data.table)
library(magrittr)
library(ggplot2)
```

## What is Sampling Bias?

Sampling bias refers to the phenomenon of a biased sample being used in a study that does not accurately represent the population being studied. This can happen in a number of ways, such as through selection bias, survivorship bias, or measurement bias. When sampling bias is present, it can lead to inaccurate results, incorrect estimates of associations between variables, and incorrect conclusions. This, in turn, can have an impact on public policy decisions, research funding, and clinical practice.

## Types of Sampling Bias

There are several types of sampling bias, including:

### 1. Selection Bias

Selection bias occurs when the selection of study participants is not random or representative of the larger population. This can happen when certain groups are excluded or overrepresented, leading to inaccurate conclusions about the study population.

For example, if a study only recruits participants from a single geographic region, the results may not be generalizable to the larger population. Similarly, if a study only recruits individuals with a certain health condition, the results may not accurately reflect the general population.

### 2. Survivorship Bias

Survivorship bias occurs when only the surviving members of a population are included in a study. This can lead to inaccurate conclusions about the population, as those who did not survive may have had different characteristics or experiences.

For example, if a study only includes individuals who survived a specific disease, the results may not be generalizable to the larger population of individuals who did not survive.

### 3. Measurement Bias

Measurement bias occurs when the measurement instruments or techniques used in a study are inaccurate or unreliable. This can result in inaccurate data and misinterpretation of results.

For example, if a study relies on self-reported data, individuals may underreport or overreport certain behaviors, leading to inaccurate conclusions about the study population. Similarly, if a study uses different measurement techniques for different groups, the results may not be comparable and may lead to inaccurate conclusions.

## Example of Sampling Bias in a Study

To better understand the impact of sampling bias on study results, let’s take a look at an example.

Suppose we want to study the relationship between smoking and lung function. We know that in our city there are 100,000 people, 20,000 of whom are smokers. To our study we recruit 5,000 smokers and 5,000 non-smokers (oversampling the smokers, a type of selection bias). We also collect data on how frequently they exercise, whether they have good genes for lung function, and whether they frequently wear hats.

We now want to overcome our selection bias when assessing the association between the outcome of lung function and the exposures of exercise, good genes, and the frequency of hat wearing.

``` r
set.seed(4)

d <- data.table(id = 1:100000)
d[, is_smoker := rbinom(.N, 1, 0.2)]
d[, probability_of_exercises_frequently := ifelse(is_smoker==T, 0.05, 0.3)]
d[, exercises_frequently := rbinom(.N, 1, probability_of_exercises_frequently)]
d[, has_good_genes := rbinom(.N, 1, 0.2)]
d[, wears_hats_frequently := rbinom(.N, 1, 0.2)]

d[, lung_function := 30 - 10 * is_smoker + 5 * exercises_frequently + 8 * has_good_genes + rnorm(.N, mean = 0, sd = 3)]

d[, probability_of_selection_uniform := 1/.N]

d[, probability_of_selection_oversample_smoker := ifelse(is_smoker==T, 5, 1)]
d[, probability_of_selection_oversample_smoker := probability_of_selection_oversample_smoker/sum(probability_of_selection_oversample_smoker)]

# We have a dataset with oversampled smokers
d_oversampled_smokers <- d[sample(1:.N, size = 5000, prob = probability_of_selection_oversample_smoker)]
(weight_smoker <- mean(d$is_smoker)/mean(d_oversampled_smokers$is_smoker))
```

    [1] 0.3700516

``` r
(weight_non_smoker <- mean(!d$is_smoker)/mean(!d_oversampled_smokers$is_smoker))
```

    [1] 1.747289

``` r
d_oversampled_smokers[, weights := ifelse(is_smoker==T, weight_smoker, weight_non_smoker)]

# The real associations:
# is_smoker: -10 (also associated with exercises_frequently!)
# exercises_frequently: +5 (also associated with is_smoker!)
# has_good_genes: +8 (only associated with outcome, not with other exposures)
# wears_hats_frequently: 0 (not associated with outcome nor other exposures)
summary(lm(lung_function ~ is_smoker + exercises_frequently + has_good_genes + wears_hats_frequently, data=d))
```

    Call:
    lm(formula = lung_function ~ is_smoker + exercises_frequently + 
        has_good_genes + wears_hats_frequently, data = d)

    Residuals:
         Min       1Q   Median       3Q      Max 
    -12.6549  -2.0112   0.0055   2.0045  12.1835 

    Coefficients:
                           Estimate Std. Error  t value Pr(>|t|)    
    (Intercept)            30.02288    0.01421 2112.751   <2e-16 ***
    is_smoker             -10.05071    0.02427 -414.150   <2e-16 ***
    exercises_frequently    4.99532    0.02250  221.992   <2e-16 ***
    has_good_genes          7.98073    0.02355  338.831   <2e-16 ***
    wears_hats_frequently  -0.01537    0.02360   -0.651    0.515    
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 2.989 on 99995 degrees of freedom
    Multiple R-squared:  0.7975,    Adjusted R-squared:  0.7975 
    F-statistic: 9.847e+04 on 4 and 99995 DF,  p-value: < 2.2e-16

``` r
# When we run the model in the full data, excluding is_smoker, we get the following associations:
# exercises_frequently: +7.2 (biased from association with is_smoker)
# has_good_genes: +8 (not biased)
# wears_hats_frequently: 0 (not biased)
summary(lm(lung_function ~ exercises_frequently + has_good_genes + wears_hats_frequently, data=d))
```

    Call:
    lm(formula = lung_function ~ exercises_frequently + has_good_genes + 
        wears_hats_frequently, data = d)

    Residuals:
        Min      1Q  Median      3Q     Max 
    -21.056  -2.670   0.928   3.445  14.532 

    Coefficients:
                           Estimate Std. Error  t value Pr(>|t|)    
    (Intercept)           2.747e+01  2.109e-02 1302.327   <2e-16 ***
    exercises_frequently  7.172e+00  3.605e-02  198.941   <2e-16 ***
    has_good_genes        7.958e+00  3.881e-02  205.044   <2e-16 ***
    wears_hats_frequently 4.393e-04  3.888e-02    0.011    0.991    
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 4.926 on 99996 degrees of freedom
    Multiple R-squared:  0.4502,    Adjusted R-squared:  0.4502 
    F-statistic: 2.73e+04 on 3 and 99996 DF,  p-value: < 2.2e-16

``` r
# When we run the model in the biased data, with oversampling of smokers (that has also an association with the outcome):
# exercises_frequently: +9.8 (biased from association with is_smoker and the biased sampling)
# has_good_genes: +7.6 (not biased)
# wears_hats_frequently: +0.3 (not biased)
summary(lm(lung_function ~ exercises_frequently + has_good_genes + wears_hats_frequently, data=d_oversampled_smokers))
```

    Call:
    lm(formula = lung_function ~ exercises_frequently + has_good_genes + 
        wears_hats_frequently, data = d_oversampled_smokers)

    Residuals:
         Min       1Q   Median       3Q      Max 
    -14.4131  -4.3613  -0.6571   4.4586  17.3734 

    Coefficients:
                          Estimate Std. Error t value Pr(>|t|)    
    (Intercept)            23.7436     0.1014 234.191   <2e-16 ***
    exercises_frequently    9.8631     0.2140  46.095   <2e-16 ***
    has_good_genes          7.6164     0.1967  38.726   <2e-16 ***
    wears_hats_frequently   0.3363     0.1905   1.765   0.0776 .  
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 5.501 on 4996 degrees of freedom
    Multiple R-squared:  0.4221,    Adjusted R-squared:  0.4218 
    F-statistic:  1217 on 3 and 4996 DF,  p-value: < 2.2e-16

``` r
# Run the model in the biased data, with weights:
# exercises_frequently: +7.4 (biased from association with is_smoker)
# has_good_genes: +7.6 (not biased)
# wears_hats_frequently: +0.3 (not biased)
summary(lm(lung_function ~ exercises_frequently + has_good_genes + wears_hats_frequently, data=d_oversampled_smokers, weights = weights))
```

    Call:
    lm(formula = lung_function ~ exercises_frequently + has_good_genes + 
        wears_hats_frequently, data = d_oversampled_smokers, weights = weights)

    Weighted Residuals:
        Min      1Q  Median      3Q     Max 
    -12.537  -4.885  -2.767   2.077  18.233 

    Coefficients:
                          Estimate Std. Error t value Pr(>|t|)    
    (Intercept)           27.33919    0.09322 293.291   <2e-16 ***
    exercises_frequently   7.40799    0.16055  46.140   <2e-16 ***
    has_good_genes         7.60104    0.17490  43.459   <2e-16 ***
    wears_hats_frequently  0.26672    0.16734   1.594    0.111    
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 4.859 on 4996 degrees of freedom
    Multiple R-squared:   0.45, Adjusted R-squared:  0.4497 
    F-statistic:  1363 on 3 and 4996 DF,  p-value: < 2.2e-16

``` r
# Run the model in the biased data, with is_smoker:
# is_smoker: -9.9 (not biased)
# exercises_frequently: +5.3 (not biased)
# has_good_genes: +7.8 (not biased)
# wears_hats_frequently: +0.2 (not biased)
summary(lm(lung_function ~ is_smoker + exercises_frequently + has_good_genes + wears_hats_frequently, data=d_oversampled_smokers))
```

    Call:
    lm(formula = lung_function ~ is_smoker + exercises_frequently + 
        has_good_genes + wears_hats_frequently, data = d_oversampled_smokers)

    Residuals:
         Min       1Q   Median       3Q      Max 
    -10.6202  -1.9903  -0.0699   1.9855  11.1052 

    Coefficients:
                          Estimate Std. Error  t value Pr(>|t|)    
    (Intercept)           29.83110    0.07786  383.149   <2e-16 ***
    is_smoker             -9.88043    0.08978 -110.051   <2e-16 ***
    exercises_frequently   5.25052    0.12300   42.688   <2e-16 ***
    has_good_genes         7.79706    0.10630   73.350   <2e-16 ***
    wears_hats_frequently  0.15569    0.10296    1.512    0.131    
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 2.973 on 4995 degrees of freedom
    Multiple R-squared:  0.8313,    Adjusted R-squared:  0.8311 
    F-statistic:  6152 on 4 and 4995 DF,  p-value: < 2.2e-16

## Conclusion

Conclusion: Biased datasets can be corrected for by either:

- Sample weights
- Including the sampling variables as covariates in the regression model
