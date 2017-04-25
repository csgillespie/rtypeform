#' Get user info out of a typeform object
#'
#' Gives a summary of the information for all visits and unique visits to the typeform questionnaire
#' survey.
#' @import dplyr
#' @param typeform A typeform object of class rtypeform_results, see ?get_results
#' @return A list containing data frame summaries for unique visits and all visits to a survey
#' @export
get_user_info = function(typeform){
  l = list()
  bools = c(TRUE,FALSE)
  labels = c("unique","all")
  for(i in seq_along(bools)){
    uniquevis = bools[i]
    times = get_ttc(typeform,uniquevis)
    crate = get_completionrate(typeform,uniquevis)
    visits = get_platform(typeform,uniquevis)
    l[[labels[i]]] = times %>% left_join(crate) %>% left_join(visits)
  }
  l
}

#' Time to complete questionnaire
#'
#' Gives a data frame summary of the time taken to complete typeform survey
#' split by platform used
#'
#' @import dplyr
#' @param typeform A typeform object of class rtypeform_results, see ?get_results
#' @param uniquevis A logical indication whether the summary should be made for unique visitors
#' only
#' @return A data frame
#' @export
get_ttc = function(typeform,uniquevis = FALSE){
  dat = get_meta(typeform,TRUE,uniquevis)
  dat %>%
    group_by(platform) %>%
    summarise(time = mean(difftime(date_submit,date_land,units = "secs"))) %>%
    rbind(cbind(platform = "all",
                dat %>%
                  summarise(time = mean(difftime(date_submit,date_land, units = "secs")))

                )
    )
}

#' Completion rate of questionnaire
#'
#' Rate of completion of a typeform questionnaire survey.
#' @import dplyr
#' @inheritParams get_ttc
#' @return A data frame
#' @export
get_completionrate = function(typeform,uniquevis = FALSE){
  dat = get_meta(typeform,FALSE,uniquevis)
  dat %>%
    group_by(platform) %>%
    summarise(completed = sum(completed), completed_perc = completed/n()) %>%
    rbind(cbind(platform = "all",
                dat %>% summarise(completed = sum(completed), completed_perc = completed/n())
                )
          )
}


#' Get platform prevalence for questionnaire
#'
#' Gives a summary data frame of the typeform questionnaire for visitors
#' using different browsing platforms
#'
#' @import dplyr
#' @param typeform A typeform object of class rtypeform_results, see ?get_results
#' @param completedonly A logical indicating whether only completed surveys should be considered
#' @param uniquevis A logical indicating whether only unique visitors should be considered
#' @return A data frame
#' @export
get_platform = function(typeform, completedonly = FALSE, uniquevis = FALSE){
  dat = get_meta(typeform,completedonly,uniquevis)
  dat %>%
    group_by(platform) %>%
    summarise(visits = n()) %>%
    mutate(visits_perc = visits/sum(visits)) %>% rbind(cbind(platform = "all",
                                       dat %>% summarise(visits = n()) %>%
                                         mutate(visits_perc = visits/sum(visits))
    )
    )
}

#' Get typeform metadata
#'
#' Returns the metadata from a typeform survey
#'
#' @inheritParams get_platform
#' @return A data frame
#' @export
get_meta = function(typeform, completedonly = FALSE, uniquevis = FALSE){
  dat = typeform$responses
  completed = as.logical(as.numeric(dat$completed))
  df = dat$metadata
  df$completed = completed

  # replace the platform == "other" with "pc"
  df$platform = replace(df$platform,df$platform == "other", "pc")

  if(completedonly)
    df = df[completed,]
  if(uniquevis)
    df = df %>% distinct(network_id, .keep_all = TRUE)
  df
}

get_visits = function(typeform, uniquevis = FALSE){
  dat = get_meta(typeform,FALSE,uniquevis)
  dat %>% group_by(platform) %>%
    summarise(total = n())
}

format_time = function(time){
  time = unclass(time)
  y <- abs(time)
  sprintf("%s%02d:%02d:%02d",
          ifelse(time < 0, "-", ""), # sign
          y %% 86400 %/% 3600,  # hours
          y %% 3600 %/% 60,  # minutes
          y %% 60 %/% 1)
}
