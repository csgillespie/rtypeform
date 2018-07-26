#' #' Questionnaire selection
#' #'
#' #' This rstudio add in is for selecting the appropriate questionnaire from the group of
#' #' questionnaires available for a given api key based on matching the questionnaire name
#' #' up with the unique id.
#' #'
#' #' @inheritParams get_typeforms
#' typeformAddin = function(api = NULL){
#'   if(!requireNamespace("shiny") || !requireNamespace("miniUI") || !requireNamespace("rstudioapi"))
#'     stop("This add in requires that both shiny and miniUI are installed.")
#'   # a modified version of get_api since if there is no key stored or provided
#'   # we want the user to be able to enter one.
#'   api_flag = TRUE
#'   api = if(is.null(api))
#'     api = Sys.getenv("typeform_api")
#'   if(nchar(api) == 0) api_flag = FALSE
#'
#'   forms = NULL
#'   is_form = FALSE
#'   if(api_flag){
#'     forms = formlist_attempt(api)
#'     is_form = is_formlist(forms)
#'   }
#'
#'   ui = miniUI::miniPage(
#'     miniUI::gadgetTitleBar("Typeform Responses"),
#'     miniUI::miniContentPanel(shiny::uiOutput("ui"))
#'   )
#'
#'   server = function(input,output,session){
#'
#'     rvs = shiny::reactiveValues(
#'       api_flag = api_flag,
#'       api = api,
#'       forms = forms,
#'       is_form = is_form
#'     )
#'     output$ui = shiny::renderUI({
#'       ## 3 cases to take care of,
#'       ## 1) no api key
#'       ## 2) bad api key
#'       ## 3) good key, forms returned
#'
#'       ## 1)
#'       if(!rvs$api_flag){ ## show a text box for api key
#'         return(shiny::div(
#'           shiny::wellPanel(
#'             shiny::textInput("api_key", "Please enter an API key")
#'           ),
#'           miniUI::miniButtonBlock(
#'             shiny::actionButton("api_submit", "Submit")
#'           )
#'         ))
#'       }
#'
#'       ## 2)
#'       else if(!rvs$is_form){
#'         shiny::div(
#'           shiny::h2("The provided api key did not give a suitable response.") ,
#'           shiny::br(),
#'           shiny::wellPanel(
#'             shiny::textInput("api_key", "Please enter an API key")
#'           ),
#'           miniUI::miniButtonBlock(
#'             shiny::actionButton("api_submit", "Submit")
#'           )
#'         )
#'       }
#'
#'       ## 3)
#'       else{
#'         shiny::div(
#'           shiny::p("Choose a questionnaire and a name to assign it to. Click done in the top right
#'                                to put put the code into the editor."),
#'           shiny::fillRow(
#'             shiny::wellPanel(
#'               shiny::selectInput("form_select",label = "Typeform questionnaires",
#'                                  choices = rvs$forms$content$name)
#'             ),
#'             shiny::wellPanel(
#'               shiny::textInput("qname", label = "Variable name", value = "tform")
#'             )
#'           )
#'         )
#'       }
#'     })
#'
#'
#'     shiny::observeEvent(input$api_submit,{
#'       api = input$api_key
#'       forms = formlist_attempt(api)
#'       is_form = is_formlist(forms)
#'
#'       if(!is_form){ ## if not a form, means an error, likely invalid key
#'         shiny::showModal(shiny::modalDialog(title = "Error",
#'                                             shiny::p("The request generated an error",shiny::br(), forms$message)))
#'       }else{
#'         #if correct, update the apiflag and value
#'         rvs$api = api
#'         rvs$api_flag = TRUE
#'         rvs$forms = forms
#'         rvs$is_form = is_form
#'       }
#'     })
#'
#'     shiny::observeEvent(input$done,{
#'       if(rvs$is_form){
#'         rstudioapi::insertText(
#'           text = paste0(input$qname, ' = get_questionnaire(uid = "',
#'                         rvs$forms$content$uid[rvs$forms$content$name == input$form_select],
#'                         '", api = "', rvs$api, '")'))
#'       }
#'       shiny::stopApp()
#'     })
#'   }
#'
#'   viewer = shiny::paneViewer(300)
#'   shiny::runGadget(ui,server,viewer = viewer)
#' }
#'
#' formlist_attempt = function(api){
#'   tryCatch(get_typeforms(api), error = function(e) e)
#' }
#'
#' is_formlist = function(typeform){
#'   if(inherits(typeform, "rtypeform_all")) return(TRUE)
#'   else FALSE # implies that it is an error
#' }
