#' Quick numerical summary of responses
#'
#' Gives a data frame which summarises the number of each response for each question as well as the
#' proportions that gave that answer.
#' @import dplyr
#' @param responses A dataframe of class typeform_response
#' @param na.rm If TRUE strip NA results from final summary
#' @return A dataframe
#' @seealso \code{\link{get_responses}}
#' @export
summarise_responses = function(responses, na.rm = TRUE){
  if(!inherits(responses,"typeform_response")) stop("responses must be of class typeform_response, see ?get_responses")
  # custom summary function for different response types?
  df = responses %>%
    group_by(Question,Response)

  if(na.rm) df = df %>% filter(!is.na(Response))
  df %>%
    summarise(Count = n()) %>%
    mutate(Percentage = Count * 100 / sum(Count))
}

#' Quick numerical summary of responses
#'
#' Gives a DT datatable view of the responses
#'
#' @inheritParams summarise_responses
#' @importFrom DT datatable
#' @export
summarise_responses_DT = function(responses,na.rm = TRUE){
  summarise_responses(responses,na.rm) %>%
    datatable
}
