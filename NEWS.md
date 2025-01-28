# rtypeform 2.1.1 _2022-12-22_
  * chore: Cleaning, linting, & namespacing
  * fix: Update typeform URLs

# rtypeform 2.1.0 _2020-08-29_
  * CRAN release

# rtypeform 2.0.3 _2020-08-28_
  * Fixed an issue introduced with dplyr 1.0.0 in handling of duplicate variable names

# rtypeform 2.0.1
  * Tidying up code
  * Update docs
  * Use Oauth

# rtypeform 2.0.0
  * Move to the new typeform API - breaking changes
  * Jumped to Version 2 to match the V2 API.

# rtypeform 0.4.0
  * Bug fix: Empty data frames now returned
  * Intended to the final version using the V1 data API. Added a start-up message.
  * Removed offset argument - seems to be broken at the typeform end.

# rtypeform 0.3.3
  * More consistent response with `get_typeforms()`.
  * Bug fix: Return an empty data frame when there are no typeforms (very edge case).
  * Bug fix: typeform API insists on integers for times; so use times.

# rtypeform 0.3.2
  * Bug fix: Return an empty data frame when there are no completed responses.
  * Bug fix: Parse hidden fields correctly

# rtypeform 0.3.1
  * Improved error messages for http status codes.
  * More consistent response with `get_questionnaire()`.

# rtypeform 0.3.0
  * Breaking changes to the API. `get_results()` now depreciated.
  Instead, use `get_questionnaire()`. This returns a list with http_status,
    question stats, questions, completed, and uncompleted responses (thanks to @hrbrmstr).

# rtypeform 0.2.1
  * Adding automatic type conversion in the `get_results()` function (thanks to @1beb).

# rtypeform 0.2.0
  * Adding user agent to API call.
  * Better error handling.
  * Export get_api function.

# rtypeform 0.1.1
  * Minor tweaks for CRAN.

# rtypeform 0.1.0
  * Initial release.
