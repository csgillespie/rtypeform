#' @importFrom assertthat assert_that
#' @export
rtypeform_set_scope = function(scopes = NULL){
  if(!is.null(scopes)){
    assert_that(is.character(scopes))
    options("rtypeform.scopes_selected" = scopes)
  }
}

#' @importFrom assertthat assert_that
#' @export
rtypeform_set_client_id = function(id = NULL){
  if(!is.null(id)){
    assert_that(is.character(id))
    options("rtypeform.client_id" = id)
  }
}

#' @importFrom assertthat assert_that
#' @export
rtypeform_set_client_secret = function(secret = NULL){
  if(!is.null(secret)){
    assert_that(is.character(secret))
    options("rtypeform.client_secret" = secret)
  }
}

#' @importFrom assertthat assert_that
#' @export
rtypeform_set_webapp_client_id = function(id = NULL){
  if(!is.null(id)){
    assert_that(is.character(id))
    options("rtypeform.webapp.client_id" = id)
  }
}

#' @importFrom assertthat assert_that
#' @export
rtypeform_set_webapp_client_secret = function(secret = NULL){
  if(!is.null(secret)){
    assert_that(is.character(secret))
    options("rtypeform.webapp.client_secret" = secret)
  }
}

