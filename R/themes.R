#' @title Theme functions
#'
#' Theme API functions
#' @importFrom httr verbose
#' @inheritParams get_api
#' @param name See https://developer.typeform.com/create/reference/create-theme/
#' @param background_href See https://developer.typeform.com/create/reference/create-theme/
#' @param background_layout See https://developer.typeform.com/create/reference/create-theme/
#' @param background_brightness See https://developer.typeform.com/create/reference/create-theme/
#' @param colors_answer See https://developer.typeform.com/create/reference/create-theme/
#' @param colors_background See https://developer.typeform.com/create/reference/create-theme/
#' @param colors_button See https://developer.typeform.com/create/reference/create-theme/
#' @param colors_question See https://developer.typeform.com/create/reference/create-theme/
#' @param font See https://developer.typeform.com/create/reference/create-theme/
#' @param has_transparent_button See https://developer.typeform.com/create/reference/create-theme/
#' @export
create_theme = function(name, api = NULL,
                        background_href = NULL, background_layout = "fullscreen",
                        background_brightness = 0,
                        colors_answer = "#4FB0AE", colors_background = "#FFFFFF",
                        colors_button="#4FB0AE", colors_question = "#3D3D3D",
                        font = "Source Sans Pro",
                        has_transparent_button = TRUE
) {
  stop("Broken API - TODO FIX")
  l = list(font = unbox(font),
           has_transparent_button = unbox(has_transparent_button),
           name = unbox(name),
           visibility = unbox("private"))

  l$background = list(brightness = unbox(background_brightness),
                      href = unbox(background_href),
                      layout = unbox(background_layout))
  l$colors = list(answer = unbox(colors_answer), background = unbox(colors_background),
                  button = unbox(colors_button), question = unbox(colors_question))
  body = jsonlite::toJSON(l, pretty = TRUE)

  url = "https://api.typeform.com/themes"
  post_response(api = api, url, body = body, content_type_json(), verbose())
}

#' @param theme_id The theme id
#' @rdname create_theme
#' @export
get_theme = function(theme_id, api = NULL) {
  url = glue::glue("https://api.typeform.com/themes/{theme_id}")
  content = get_response(api, url)
  content %>%
    flatten_df()
}



#' @rdname create_theme
#' @inheritParams get_forms
#' @importFrom rlang .data
#' @export
get_themes = function(api = NULL, page = 1, page_size = 10) {
  page = create_argument(page)
  page_size = create_argument(page_size)

  url = glue::glue("https://api.typeform.com/themes?{page}&{page_size}")
  content = get_response(api = api, url)
  items = content$items
  backgrounds = items %>%
    select(-.data$colors, -.data$background) %>%
    as_tibble() %>%
    bind_cols(items$colors, items$background)

  attr(backgrounds, "total_items") = content$total_items
  attr(backgrounds, "page_count") = content$page_count
  backgrounds
}


#' @rdname create_theme
#' @export
update_theme = function(theme_id, name, api = NULL,
                     background_href = NULL, background_layout = "fullscreen",
                     background_brightness = 0,
                     colors_answer = "#4FB0AE", colors_background = "#FFFFFF",
                     colors_button="#4FB0AE", colors_question = "#3D3D3D",
                     font = "Source Sans Pro",
                     has_transparent_button = TRUE) {
  stop("Broken API - TODO FIX")
  url = glue("https://api.typeform.com/themes/{theme_id}")
  put_response(api = api, url)
}


#' @rdname create_theme
#' @export
delete_theme = function(theme_id, api = NULL) {
  url = glue("https://api.typeform.com/themes/{theme_id}")
  delete_response(api = api, url = url)
}
