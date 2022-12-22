#' Theme functions
#'
#' Theme API functions
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
                        colors_button = "#4FB0AE", colors_question = "#3D3D3D",
                        font = "Source Sans Pro",
                        has_transparent_button = TRUE
) {
  stop("Broken API - TODO FIX")
  l = list(font = jsonlite::unbox(font),
           has_transparent_button = jsonlite::unbox(has_transparent_button),
           name = jsonlite::unbox(name),
           visibility = jsonlite::unbox("private"))

  l$background = list(brightness = jsonlite::unbox(background_brightness),
                      href = jsonlite::unbox(background_href),
                      layout = jsonlite::unbox(background_layout))
  l$colors = list(answer = jsonlite::unbox(colors_answer),
                  background = jsonlite::unbox(colors_background),
                  button = jsonlite::unbox(colors_button),
                  question = jsonlite::unbox(colors_question))
  body = jsonlite::toJSON(l, pretty = TRUE)

  url = "https://api.typeform.com/themes"
  post_response(api = api, url, body = body, httr::content_type_json(), httr::verbose())
}

#' @param theme_id The theme id
#' @rdname create_theme
#' @export
get_theme = function(theme_id, api = NULL) {
  url = glue::glue("https://api.typeform.com/themes/{theme_id}")
  content = get_response(api, url)
  purrr::flatten_df(content)
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
    dplyr::select(-"colors", -"background") %>%
    dplyr::as_tibble() %>%
    dplyr::bind_cols(items$colors, items$background)

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
                        colors_button = "#4FB0AE", colors_question = "#3D3D3D",
                        font = "Source Sans Pro",
                        has_transparent_button = TRUE) {
  stop("Broken API - TODO FIX")
  url = glue::glue("https://api.typeform.com/themes/{theme_id}")
  put_response(api = api, url)
}

#' @rdname create_theme
#' @export
delete_theme = function(theme_id, api = NULL) {
  url = glue::glue("https://api.typeform.com/themes/{theme_id}")
  delete_response(api = api, url = url)
}
