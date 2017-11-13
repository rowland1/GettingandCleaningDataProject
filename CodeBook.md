Course2Project
================

Codebook

This codebook was generated on 11/13/2017 to reflect detailed steps that generated the dataset entitled "tidy.txt". See run\_analysis.r for actual code.

Variable list and descriptions:

Variable Name Description

Activity Action being measured Subject ID of the subject who performed the activity *Acc Feature: Acceleration signal (body or gravity) *Jerk Feature: Jerk signal for body feature *Gyro Measuring instrument *Mag Magnitude of the signals *f/t/a Domain: frequency, time or angle Variable Mean or std *X/Y/Z 3 - axial signals

Specific variable names:

``` r
load("GettingCleaningData-Env.RData")
names(dt_tidy)
```

    ## Error in eval(expr, envir, enclos): object 'dt_tidy' not found

Data Structure:

``` r
str(dt_tidy)
```

    ## Error in str(dt_tidy): object 'dt_tidy' not found

First 10 rows and last 5 rows of data set:

``` r
head(dt_tidy, n=10)
```

    ## Error in head(dt_tidy, n = 10): object 'dt_tidy' not found

``` r
tail(dt_tidy, n=5)
```

    ## Error in tail(dt_tidy, n = 5): object 'dt_tidy' not found

Dimensions:

``` r
dim(dt_tidy)
```

    ## Error in eval(expr, envir, enclos): object 'dt_tidy' not found

Class:

``` r
class(dt_tidy)
```

    ## Error in eval(expr, envir, enclos): object 'dt_tidy' not found

Summary:

``` r
summary(dt_tidy)
```

    ## Error in summary(dt_tidy): object 'dt_tidy' not found
