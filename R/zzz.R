.onAttach <- function(...) {
  msg = glue::glue("This package now uses V2 of the typeform API.\\
       This update breaks ALL code (sorry, not my fault).\\
       The README provides some guidence on using the new functions.\\
       You will need to generate a new API. See the README

       https://cran.r-project.org/web/packages/rtypeform/readme/README.html

       for details.")
  packageStartupMessage(msg)
}
