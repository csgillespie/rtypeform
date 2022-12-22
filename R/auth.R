#' Create an OAuth token
#'
#' Create a token object using the client id and secret options set, together
#' with the defined scopes.
#'
#' @export
make_new_token = function() {
  key = getOption("rtypeform.client_id", "")
  secret = getOption("rtypeform.client_secret", "")
  scope = getOption("rtypeform.scopes_selected", "")

  if (key == "" || is.null(key)) {
    stop("option('rtypeform.client_id') has not been set")
  }
  if (secret == "" || is.null(secret)) {
    stop("option('rtypeform.client_secret') has not been set")
  }
  if ((length(scope) == 1 && scope == "") || is.null(scope)) {
    stop("option('rtypeform.scopes_selected') has not been set")
  }

  app = httr::oauth_app("typeform", key = key, secret = secret)
  endpoint = httr::oauth_endpoint(authorize = "https://api.typeform.com/oauth/authorize",
                            access = "https://api.typeform.com/oauth/token")

  typeform_token = httr::oauth2.0_token(endpoint = endpoint,
                                  app = app,
                                  scope = scope)
  typeform_token
}
