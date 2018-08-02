#' @rdname get_teams
#' @export
get_number_of_seats = function(api = NULL) {
  teams = get_teams(api)
  attr(teams, "total_seats")
}

#' Get team members
#'
#' Return a tibble containing the current team members. The
#' total number of seats is attached via an attribute.
#' @inheritParams get_api
#' @export
get_teams = function(api = NULL) {
  url = "https://api.typeform.com/teams/mine"
  content = get_response(api, url)
  members = as_tibble(content$members)
  attr(members, "total_seats") = content$total_seats
  members
}
