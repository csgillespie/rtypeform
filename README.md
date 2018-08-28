<!-- README.md is generated from README.Rmd. Please edit that file -->

# API to typeform data sets

[![Build
Status](https://travis-ci.org/csgillespie/rtypeform.svg?branch=master)](https://travis-ci.org/csgillespie/rtypeform)
[![Downloads](http://cranlogs.r-pkg.org/badges/rtypeform?color=brightgreen)](https://cran.r-project.org/package=rtypeform)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/rtypeform)](https://cran.r-project.org/package=rtypeform)
[![codecov.io](https://codecov.io/github/csgillespie/rtypeform/coverage.svg?branch=master)](https://codecov.io/github/csgillespie/rtypeform?branch=master)

[Typeform](http://referral.typeform.com/mzcsnTI) is a company that
specializes in online form building. This R package allows users to
download their form results through the exposed API (V2).

\*\* The `rtypeform` package now uses V2. This is a breaking change from
the previous version.\*\*

## Installation

The package can be installed from CRAN

``` r
install.packages("rtypeform")
```

and loaded in the usual way.

``` r
library("rtypeform")
#> This package now uses V2 of the typeform API.This update breaks ALL code (sorry, not my fault).The README provides some guidence on using the new functions.You will need to generate a new API. See the README for details.
```

## Obtaining an API key

To use this package you need a **V2** API key. It is fairly easy to
obtain one. See typeform’s [help
page](https://developer.typeform.com/get-started/personal-access-token/).
The token will look something like

> 943af478d3ff3d4d760020c11af102b79c440513

Whenever the package refers to `api`, this is the object it needs.

## Using the package

Once you have this key, we can extract data from typeform

``` r
api = "XXXXX"
# Was get_typeforms() in V1 of the package
forms = get_forms(api)
```

The forms object is also contains attributes containing the total number
of forms.

``` r
attr(forms, "total_items")
#> [1] 5
```

If you don’t pass your `api` key as an argument, it will attempt to read
the variable `typeform_api2` from your `.Renviron` file, via
`Sys.getenv("typeform_api2")`. If this variable is set correctly, then
you can **omit** the `api` argument

``` r
# See ?get_forms for further details
forms = get_forms()
```

In all function calls below, the `api` argument can be omitted if the
environment variable is set (see Efficient R programming
[Chapter 2](https://csgillespie.github.io/efficientR/set-up.html#renviron)
for more details).

You can download data from a particular typeform via

``` r
# Most recent typeform
form_id = forms$form_id[1]
q = get_responses(form_id, completed = TRUE)
```

The object `q` is a list. The first element is `meta` that contain
details on the user, such as, their `platform` and `user_agent`. The
other list elements are responses to each question.

There are a number of options for downloading the data. For example

``` r
q = get_responses(form_id, completed = TRUE, page_size = 100)
```

See the `?get_responses()` help page for other options.

### Looking at the responses

Since the responses is list, we get to perform lots of map operations. I
find using `purrr` and the `tidyverse` make this a bit easier. To see
the question types we can use string a few `map()` commands together

``` r
library("tidyverse")
question_types = q[-1] %>% # Remove the meta
   map(~select(.x, type)) %>%
   map_df(~slice(.x, 1)) %>%
   pull()
```

### Example: Multiple Filters / Order

Imagine we only want:

  - completed results, so we add the parameter `completed = TRUE`.
  - a maximum of 5 results, so we add the parameter `page_size = 5`.
  - results since `2018-01-01 11:00:00`.

<!-- end list -->

``` r
since = "2018-01-01 11:00:00"
# convert to date-time 
since = lubridate::ymd_hms(since)
q = get_responses(form_id, completed = TRUE, 
                  page_size = 5, since = since)
```

## Other information

  - If you have any suggestions or find bugs, please use the github
    [issue tracker](https://github.com/csgillespie/rtypeform/issues).
  - Feel free to submit pull requests.

-----

Development of this package was supported by [Jumping
Rivers](https://www.jumpingrivers.com)
