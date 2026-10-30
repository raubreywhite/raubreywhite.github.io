# Sparse inference

Examining sparse inference using both frequentist and bayesian methodology.

Author

[Richard Aubrey White](https://www.rwhite.no) [![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMC1jMDYwIDYxLjEzNDc3NywgMjAxMC8wMi8xMi0xNzozMjowMCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo1N0NEMjA4MDI1MjA2ODExOTk0QzkzNTEzRjZEQTg1NyIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDozM0NDOEJGNEZGNTcxMUUxODdBOEVCODg2RjdCQ0QwOSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDozM0NDOEJGM0ZGNTcxMUUxODdBOEVCODg2RjdCQ0QwOSIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkZDN0YxMTc0MDcyMDY4MTE5NUZFRDc5MUM2MUUwNEREIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjU3Q0QyMDgwMjUyMDY4MTE5OTRDOTM1MTNGNkRBODU3Ii8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+84NovQAAAR1JREFUeNpiZEADy85ZJgCpeCB2QJM6AMQLo4yOL0AWZETSqACk1gOxAQN+cAGIA4EGPQBxmJA0nwdpjjQ8xqArmczw5tMHXAaALDgP1QMxAGqzAAPxQACqh4ER6uf5MBlkm0X4EGayMfMw/Pr7Bd2gRBZogMFBrv01hisv5jLsv9nLAPIOMnjy8RDDyYctyAbFM2EJbRQw+aAWw/LzVgx7b+cwCHKqMhjJFCBLOzAR6+lXX84xnHjYyqAo5IUizkRCwIENQQckGSDGY4TVgAPEaraQr2a4/24bSuoExcJCfAEJihXkWDj3ZAKy9EJGaEo8T0QSxkjSwORsCAuDQCD+QILmD1A9kECEZgxDaEZhICIzGcIyEyOl2RkgwAAhkmC+eAm0TAAAAABJRU5ErkJggg==)](https://orcid.org/0000-0002-6747-1726)

Published

April 14, 2023

## Introduction

Machine learning and statistical modeling are two important tools in data science that are used to make predictions and infer relationships between variables, respectively. Models for prediction aim to estimate the relationship between inputs and outputs in order to make accurate predictions about new, unseen data. In contrast, models for inference aim to understand the underlying relationships between variables in the data, often in the form of identifying causal relationships.

In this blog post, we will explore using models for inference using a simulated dataset, and we will apply penalized regression to perform feature selection on a binary outcome. Penalized regression is particularly useful in situations where the number of predictors (i.e. independent variables) is much larger than the sample size.

We will investigate the frequentist solution of using a two-stage solution with LASSO regression via `glmnet` and then using the `selectiveInference` package to perform post inference and adjust for the bias introduced by the selection process. We will also investigate a Bayesian solution that approximates a LASSO regression via a Laplace prior.

## Simulating a Dataset

We will simulate a dataset with `n = 5000` people and `p = 50` variables, where only three of the 50 variables will have an association with the binary outcome, and they will have odds ratios of 4, 3, and 2. The remaining variables will have no association with the outcome.

``` r
library(data.table)
library(magrittr)
library(ggplot2)

set.seed(123)
n <- 5000
p <- 50
x <- matrix(rnorm(n * p), nrow = n)
beta <- c(log(4), log(3), log(2), rep(0, 47))
prob <- plogis(x %*% beta)
y <- rbinom(n, 1, prob)

data <- data.frame(cbind(y,x))
colnames(data) <- c("y", paste0("x",1:ncol(x)))

x <- model.matrix(y ~ ., data = data)[,-1]
y <- data$y
```

## LASSO Regression

We will now fit a LASSO regression model using the `glmnet` package in R. LASSO is a popular method for feature selection in high-dimensional data, where the number of predictors `p` is much larger than the number of observations `n`.

``` r
# get standard deviation of X, because we will need to standardize/scale it outside of glmnet
sds <- apply(x, 2, sd)

# standardize x
x_scaled <- scale(x,TRUE,TRUE)

# run glmnet
cfit <- glmnet::cv.glmnet(x_scaled,y,standardize=FALSE, family="binomial")
coef(cfit)
```

    51 x 1 sparse Matrix of class "dgCMatrix"
                         s1
    (Intercept) 0.008303975
    x1          1.081745656
    x2          0.821477348
    x3          0.452041341
    x4          .          
    x5          .          
    x6          .          
    x7          .          
    x8          .          
    x9          .          
    x10         .          
    x11         .          
    x12         .          
    x13         .          
    x14         .          
    x15         .          
    x16         .          
    x17         .          
    x18         .          
    x19         .          
    x20         .          
    x21         .          
    x22         .          
    x23         .          
    x24         .          
    x25         .          
    x26         .          
    x27         .          
    x28         .          
    x29         .          
    x30         .          
    x31         .          
    x32         .          
    x33         .          
    x34         .          
    x35         .          
    x36         .          
    x37         .          
    x38         .          
    x39         .          
    x40         .          
    x41         .          
    x42         .          
    x43         .          
    x44         .          
    x45         .          
    x46         .          
    x47         .          
    x48         .          
    x49         .          
    x50         .          

## No confidence intervals

Note that LASSO regression does not provide any confidence intervals or p-values, only coeficient estimates.

### Inference

LASSO regression is a popular method for variable selection in high-dimensional datasets. It shrinks some coefficients to zero, allowing us to select only a subset of variables that have the strongest association with the outcome. However, LASSO does not provide confidence intervals or p-values for the selected variables.

The reason for this is that LASSO performs variable selection by penalizing the likelihood function, not by explicitly testing the significance of each variable. Therefore, we cannot use traditional methods to compute confidence intervals or p-values. Instead, we need to use methods that are specifically designed for post-selection inference.

One such method is provided in the R package `selectiveInference.` The function `fixedLassoInf` provides confidence intervals and p-values for LASSO selected variables by accounting for the fact that variable selection was performed. It does this by using a two-stage procedure. In the first stage, LASSO selects a subset of variables. In the second stage, selectiveInference performs inference on the selected variables, adjusting for the selection procedure.

> **WARNING:**
>
> It is important to use `selectiveInference` rather than naively using simpler (but incorrect) methods that do not take into account the two-stage process.
>
> A simpler (but incorrect) method involves first selecting variables with LASSO and then fitting a traditional logistic regression on the selected variables. However, this can lead to biased estimates because the LASSO selection process ignores the uncertainty in the variable selection. Therefore, the second-stage regression will not account for the fact that the variable selection was performed, leading to over-optimistic estimates of the significance of the selected variables.
>
> By using `selectiveInference`, we can properly account for the selection process and obtain unbiased estimates of the significance of the selected variables.

``` r
# compute fixed lambda p-values and selection intervals
out <- selectiveInference::fixedLassoInf(
  x = x_scaled,
  y = y,
  beta = coef(cfit),
  lambda = cfit$lambda.1se,
  alpha = 0.05,
  family = "binomial"
)

retval <- data.frame(
  var = names(out$vars),
  Odds_Ratio = exp(out$coef0/sds[out$vars]),
  LowConf = exp(out$ci[,1]/sds[out$vars]),
  UpperConf = exp(out$ci[,2]/sds[out$vars]),
  pval = out$pv
)
row.names(retval) <- NULL
retval$var[retval$pval < 0.05] <- paste0("*", retval$var[retval$pval < 0.05])
names(retval) <- c(
  "Variable",
  "Odds ratio",
  "Conf int 5%",
  "Conf int 95%",
  "Pvalue"
)
retval
```

      Variable Odds ratio Conf int 5% Conf int 95% Pvalue
    1      *x1   3.761571    3.471404     4.073621      0
    2      *x2   2.793509    2.594666     3.007784      0
    3      *x3   1.848946    1.727840     1.979062      0

## Bayesian Logistic Regression using `rstanarm`

Another way to perform inference on a logistic regression model with feature selection is through Bayesian methods. In particular, we can use the `rstanarm` R package to fit a Bayesian logistic regression model with a Laplace prior.

## Laplace prior

The Laplace prior is used to promote sparsity by assigning a probability distribution to the coefficients that puts more probability mass around zero. It is equivalent to LASSO regression ([Tibshirani 1996](#ref-Tibshirani1996)).

``` r
options(mc.cores = parallel::detectCores())

fit <- rstanarm::stan_glm(
  formula = y ~ .,
  data = data,
  family = binomial(),
  prior = rstanarm::laplace(),
  chains = 4,
  iter = 5000,
  refresh=0
)

retval <- data.frame(
  var = names(coef(fit)),
  Odds_Ratio = round(exp(coef(fit)),3),
  round(exp(rstanarm::posterior_interval(fit, prob = 0.9)),3),
  pvalue_equivalent = round(bayestestR::pd_to_p(bayestestR::p_direction(fit)$pd),2)
)
row.names(retval) <- NULL
retval$var[retval$pvalue_equivalent < 0.05] <- paste0("*", retval$var[retval$pvalue_equivalent < 0.05])
names(retval) <- c(
  "Variable",
  "Odds ratio",
  "Cred int 5%",
  "Cred int 95%",
  "Pvalue equivalent"
)
retval
```

          Variable Odds ratio Cred int 5% Cred int 95% Pvalue equivalent
    1  (Intercept)      1.009       0.951        1.072              0.81
    2          *x1      4.046       3.742        4.382              0.00
    3          *x2      2.965       2.761        3.193              0.00
    4          *x3      1.931       1.810        2.061              0.00
    5           x4      0.953       0.898        1.010              0.17
    6           x5      1.018       0.961        1.078              0.59
    7           x6      0.999       0.942        1.059              0.98
    8           x7      0.985       0.928        1.043              0.65
    9           x8      0.973       0.918        1.032              0.45
    10          x9      0.961       0.906        1.021              0.26
    11         x10      0.998       0.941        1.058              0.95
    12         x11      1.041       0.980        1.108              0.26
    13         x12      0.962       0.908        1.021              0.29
    14         x13      1.039       0.978        1.104              0.29
    15         x14      1.002       0.942        1.066              0.95
    16         x15      0.999       0.942        1.058              0.97
    17         x16      0.960       0.905        1.017              0.24
    18         x17      1.031       0.972        1.096              0.39
    19         x18      0.958       0.902        1.016              0.23
    20         x19      0.993       0.937        1.053              0.84
    21         x20      1.008       0.949        1.069              0.83
    22         x21      0.985       0.928        1.043              0.66
    23         x22      1.043       0.985        1.106              0.23
    24         x23      0.958       0.902        1.016              0.22
    25         x24      0.997       0.939        1.058              0.94
    26         x25      1.039       0.977        1.106              0.29
    27         x26      0.980       0.925        1.036              0.58
    28         x27      1.039       0.980        1.101              0.29
    29         x28      1.013       0.955        1.075              0.71
    30         x29      1.023       0.963        1.087              0.54
    31         x30      1.006       0.948        1.067              0.86
    32        *x31      0.904       0.851        0.960              0.01
    33         x32      1.026       0.967        1.089              0.47
    34         x33      1.032       0.973        1.096              0.39
    35         x34      1.001       0.943        1.063              0.97
    36         x35      1.006       0.950        1.068              0.85
    37         x36      1.049       0.990        1.114              0.17
    38         x37      1.024       0.965        1.086              0.52
    39         x38      1.060       1.001        1.125              0.10
    40         x39      1.021       0.962        1.084              0.57
    41         x40      1.030       0.971        1.092              0.41
    42         x41      0.986       0.928        1.046              0.69
    43         x42      1.006       0.949        1.068              0.87
    44         x43      1.026       0.967        1.090              0.49
    45         x44      0.948       0.893        1.005              0.13
    46         x45      1.043       0.982        1.109              0.23
    47         x46      1.012       0.954        1.072              0.73
    48         x47      1.005       0.948        1.065              0.88
    49         x48      0.953       0.899        1.010              0.17
    50         x49      0.960       0.905        1.018              0.25
    51         x50      0.969       0.913        1.025              0.35

## P-value equivalent

Probability of Direction (PoD) and p-values are both statistical measures used in hypothesis testing Makowski, Ben-Shachar, Chen, et al. ([2019](#ref-Makowski2019Indices)). They are similar in that they both provide evidence for or against a null hypothesis. PoD measures the proportion of posterior draws from a Bayesian model that are in the direction of the alternative hypothesis. It provides a measure of the strength of evidence for the alternative hypothesis relative to the null hypothesis. A high PoD value indicates strong evidence in favor of the alternative hypothesis, while a low PoD value indicates weak evidence in favor of the alternative hypothesis.

Similarly, a p-value measures the probability of obtaining a test statistic as extreme as or more extreme than the observed value, assuming that the null hypothesis is true. A low p-value indicates that the observed result is unlikely to have occurred by chance alone, providing evidence against the null hypothesis.

To convert PoD to a p-value equivalent, one approach is to use the following formula:

p-value = 2 \* min(PoD, 1-PoD)

This formula assumes a two-tailed test and converts the PoD to a p-value for a test of the null hypothesis that the effect size is equal to zero. The resulting p-value can be interpreted as the probability of obtaining the observed result or a more extreme result under the null hypothesis.

## Conclusion

The blog article discusses the limitations of using LASSO (Least Absolute Shrinkage and Selection Operator) models for statistical inference, particularly in situations where the number of predictors (i.e. independent variables) is much larger than the sample size. In these cases, LASSO models can suffer from high variability in the estimated coefficients, which can lead to incorrect or unreliable conclusions.

One proposed solution to this problem is to use a two-stage inference approach, where LASSO is first used to select a subset of predictors, and then a separate statistical method (such as ordinary least squares) is used to estimate the coefficients for the selected predictors. However, this two-stage approach can also have limitations, such as a loss of power in the second stage and increased computational complexity.

In contrast, Bayesian statistics offer a one-stage inference approach that can provide more reliable and interpretable results in complex modeling situations. Bayesian statistics allow for the incorporation of prior knowledge and uncertainty in the model, which can help to reduce variability and improve accuracy. Bayesian methods also provide a framework for model comparison and selection, which can help to identify the most appropriate model for a given dataset.

Overall, while LASSO models can be useful in certain situations, their limitations in high-dimensional data settings highlight the advantages of Bayesian statistics for reliable and interpretable statistical inference.

## References

Makowski, Dominique, Matthew S Ben-Shachar, Simon H A Chen, and Daniel Lüdecke. 2019. “Indices of Effect Existence and Significance in the Bayesian Framework.” *Frontiers in Psychology* 10: 2767. <https://doi.org/10.3389/fpsyg.2019.02767>.

Makowski, Dominique, Matthew S Ben-Shachar, and Daniel Lüdecke. 2019. “bayestestR: Describing Effects and Their Uncertainty, Existence and Significance Within the Bayesian Framework.” *Journal of Open Source Software* 4 (40): 1541. <https://doi.org/10.21105/joss.01541>.

Tibshirani, Robert. 1996. “Regression Shrinkage and Selection via the Lasso.” *Journal of the Royal Statistical Society. Series B (Methodological)* 58 (1): 267–88. <http://www.jstor.org/stable/2346178>.
