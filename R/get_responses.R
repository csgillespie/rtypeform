#' Extract questionnaire results
#'
#' Pull results for selected questions from a given questionnaire
#' @import dplyr
#' @importFrom tidyr unite_
#' @param typeform A single typeform questionnaire, perhaps as a result of get_results()
#' @param qid A numeric vector corresponding to the field_id of the given typeform question(s)
#' @return A dataframe with class typeform_response
#' @export
get_responses = function(typeform, qid = typeform$questions$field_id, na.rm = FALSE){

  raw = get_raw_responses(typeform,qid,na.rm) # see TODO in this function

  df = reshape2::melt(raw , id.vars = NULL)
  colnames(df) = c("Question", "Response")

  class(df) = c("typeform_response",class(df))
  df
}

#'@export
get_raw_responses = function(typeform, qid = typeform$questions$field_id, na.rm = FALSE){
  qid = typeform$questions$id[which(typeform$questions$field_id %in% qid)]
  raw = typeform$responses$answers[
    intersect(qid,colnames(typeform$responses$answers))
    ]
  names = typeform$questions$question[typeform$questions$id %in% intersect(qid,colnames(typeform$responses$answers))]
  # something different seems to happen for "other" on multiple choice
  # merge the columns for same field ID, for "other" choice
  # on list answers this stops it being treated as a separate
  # question
  # grouped questions id don't appear in answers, which is a pain
  fid = typeform$questions$field_id
  # names = typeform$questions$question
  raw = do.call(cbind,lapply(unique(fid), function(x){
    trouble = grepl(x,colnames(raw)) #fid == x
    cols = which(trouble)
    d = raw[,cols,drop = FALSE]
    if(sum(trouble) > 1){
      name = unique(names[cols])
      d[is.na(d)] = ""
      d = unite_(d,name,colnames(d)[cols], sep = "")
      d[d == ""] = NA
      d
    }else{
      colnames(d) = names[cols]
      d
    }
  }))

  ## TODO add in the possibility to strip NA's from data.
  # if(na.rm){
  #   raw =
  # }

  return(raw)
}

#' Extract question field ID's
#'
#' Returns an easy to read data frame to facilitate easier matching of questions to
#' field_id numbers
#' @import dplyr
#' @param typeform A single typeform questionnaire, perhaps as a result of get_results()
#' @return A dataframe of questions and ids
#' @export
get_qid= function(typeform){
  typeform$questions %>%
    mutate(field_id = replace(field_id, grepl("group",id),"")) %>%
    select(question,field_id) %>%
    unique
}

#' @export
find_qid = function(typeform, q){
  (typeform$question %>%
    filter(question %in% q) %>%
    select(field_id) %>% unique)[,1]
}
