# Version 0.3.0
  * Breaking changes to the API. `get_results()` now depreciated. 
  Instead, use `get_questionnaire()`. This returns a list with http_status, 
    question stats, questions, completed, and uncompleted responses (thanks to @hrbrmstr).

# Version 0.2.1
  * Adding automatic type conversion in the `get_results()` function (thanks to @1beb).

# Version 0.2.0
  * Adding user agent to API call.
  * Better error handling.
  * Export get_api function.

# Version 0.1.1
  * Minor tweaks for CRAN.

# Version 0.1.0
  * Initial release.
