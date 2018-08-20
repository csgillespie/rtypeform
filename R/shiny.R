# stuff for shiny authentication

#' Get the Shiny Apps URL.
#'
#' Needed for the redirect URL in Auth flow
#'
#' @param session The shiny session object.
#'
#' @return The URL of the Shiny App its called from.
rtypeform_shiny_get_url = function(session){
  if(!is.null(session)){
    pathname = session$clientData$url_pathname
    hostname = session$clientData$url_hostname
    port = session$clientData$url_port

    url = paste0(session$clientData$url_protocol,
                  "//",
                  hostname,
                  if(port != "") paste0(":", port),
                  if(pathname != "/") pathname)

    message("Shiny URL detected as: ", url)
    url
  } else {
    NULL
  }
}

#' Returns the authentication parameter "code" in redirected URLs
#'
#' Checks the URL of the Shiny app to get the state and code URL parameters.
#'
#' @param session A shiny session object
#'
#' @return The auth token in the code URL parameter.
#' @family shiny auth functions
#' @keywords internal
rtypeform_auth_return_code = function(session){
  check_package_loaded("shiny")
  pars = shiny::parseQueryString(session$clientData$url_search)
  if(!is.null(pars$code)){
    return(pars$code)
  } else {
    NULL
  }
}

#' @importFrom httr modify_url oauth_endpoint
rtypeform_shiny_get_auth_url = function(redirect.uri,
           client.id     = getOption("rtypeform.webapp.client_id"),
           client.secret = getOption("rtypeform.webapp.client_secret"),
           scope         = getOption("rtypeform.scopes_selected"),
           access_type   = c("online","offline"),
           approval_prompt = c("auto","force")) {

    access_type = match.arg(access_type)
    approval_prompt = match.arg(approval_prompt)

    scopeEnc = paste(scope, sep='', collapse=' ')

    ## httr friendly version
    url = modify_url(
      oauth_endpoint(authorize = "https://api.typeform.com/oauth/authorize",
                                access = "https://api.typeform.com/oauth/token")$authorize,
      query = list(response_type = "code",
                   client_id = client.id,
                   redirect_uri = redirect.uri,
                   scope = scopeEnc,
                   access_type = access_type,
                   approval_prompt = approval_prompt))
    message("Auth Token URL: ", url)
    url
  }

#' @importFrom httr oauth_app POST headers content Token2.0 oauth_endpoints
rtypeform_shiny_get_token = function(redirect_uri, client_id, client_secret){

  typeform_app = oauth_app("typeform", key = client_id, secret= client_secret)
  scope_list = getOption("rtypeform.scopes_selected")

  req = POST("https://api.typeform.com/oauth/authorize",
             body = list(
               client_id = client_id,
               client_secret = client_secret,
               redirect_uri = redirect_uri,
               scope = scope_list
             ))

  stopifnot(identical(headers(req)$`content-type`,
                      "application/json; charset=utf-8"))
  # content of req will contain access_token, token_type, expires_in
  token <- content(req, type = "application/json")

  # Create a Token2.0 object consistent with the token obtained from gar_auth()
  Token2.0$new(app = typeform_app,
               endpoint = oauth_endpoint(authorize = "https://api.typeform.com/oauth/authorize",
                                         access = "https://api.typeform.com/oauth/token"),
               credentials = list(access_token = token$access_token,
                                  token_type = token$token_type,
                                  expires_in = token$expires_in,
                                  refresh_token = token$refresh_token),
               params = list(scope = scope_list, type = NULL,
                             use_oob = FALSE, as_header = TRUE),
               cache_path = FALSE)
}

#' @export
rtypeform_auth_ui = function(id){
  check_package_loaded("shiny")
  ns = shiny::NS(id)
  shiny::uiOutput(ns("rtypeform_auth_ui"))
}

#' @export
rtypeform_auth_serve = function(input,output,session,
                                login_text="Login via Typeform",
                                logout_text="Logout",
                                login_class="btn btn-primary",
                                logout_class="btn btn-default",
                                access_type = c("online","offline"),
                                approval_prompt = c("auto","force")){
  check_package_loaded("shiny")
  access_type = match.arg(access_type)
  approval_prompt = match.arg(approval_prompt)
  ns = session$ns
  accessToken = shiny::reactive({

    ## gets all the parameters in the URL. The auth code should be one of them.
    if(!is.null(rtypeform_auth_return_code(session))){
      ## extract the authorization token
      app_url = rtypeform_shiny_get_url(session)
      access_token = rtypeform_shiny_get_token(rtypeform_auth_return_code(session), app_url)
      access_token
    } else {
      NULL
    }
  })

  output$rtypeform_auth_ui = shiny::renderUI({

    if(is.null(shiny::isolate(accessToken()))) {
      shiny::actionLink(ns("signed_in"),
                        shiny::a(login_text,
                                 href = rtypeform_shiny_get_auth_url(rtypeform_shiny_get_url(session),
                                                             access_type = access_type,
                                                             approval_prompt = approval_prompt),
                                 class=login_class,
                                 role="button"))
    } else {
        logout_button = shiny::a(logout_text,
                                  href = rtypeform_shiny_get_url(session),
                                  class=logout_class,
                                  role="button")
        logout_button
      }
  })

  return(accessToken)
}


