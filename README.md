<!-- README.md is generated from README.Rmd. Please edit that file -->
API to typeform data sets
=========================

[![Build Status](https://travis-ci.org/csgillespie/rtypeform.svg?branch=master)](https://travis-ci.org/csgillespie/rtypeform) [![Downloads](http://cranlogs.r-pkg.org/badges/rtypeform?color=brightgreen)](http://cran.rstudio.com/package=rtypeform) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/rtypeform)](https://cran.r-project.org/package=rtypeform) [![codecov.io](https://codecov.io/github/csgillespie/rtypeform/coverage.svg?branch=master)](https://codecov.io/github/csgillespie/rtypeform?branch=master)

[Typeform](https://typeform.com) is a company that specialises in online form building. This R package allows users to download their form results through the exposed API.

Installation
------------

The package can be installed from CRAN

``` r
install.packages("rtypeform")
```

or you can install the development version via `devtools`

``` r
devtools::install_github("csgillespie/rtypeform")
```

The package can then be loaded in the usual way

``` r
library("rtypeform")
```

Using the package
-----------------

To use this package, you will need a [data API](https://www.typeform.com/help/data-api/) key. With this key in position, you can then list your available forms

``` r
api = "XXXXX"
typeforms = get_all_typeforms(api)
```

If you don't pass your `api` key as an argument, it will attempt to read the variable `Sys.getenv("typeform_api")`.

You can download data from a particular typeform via

``` r
## uid can be obtained from the typeforms data set above
get_results(uid, api)
```

There are a number of options for downloading the data. For example

``` r
## Only completed forms
get_results(uid, api, completed=TRUE)
## Results since the 1st Jan
get_results(uid, api, since=as.Date("2016-01-01"))
```

See the `?get_results` help page for other options.

Example: Multiple Filters / Order
---------------------------------

Imagine we only want to fetch only the last 10 completed responses.

-   We only want completed results, so we add the parameter `completed=TRUE`.
-   The results need to be ordered by newest results first, so we add the parameter `order_by="date_submit_desc"`
-   We only want 10 results maximum, so we add the parameter `limit=10`

This gives the function call

``` r
get_results(uid, api, completed=TRUE, order_by="date_submit_desc", limit=10)
```

Other information
-----------------

-   If you have any suggestions or find bugs, please use the github [issue tracker](https://github.com/csgillespie/typeform/issues).
-   Feel free to submit pull requests.
