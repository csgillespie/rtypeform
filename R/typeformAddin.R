#' @export
typeformAddin = function(api = NULL){
  # a modified version of get_api since if there is no key stored or provided
  # we want the user to be able to enter one.
  api_flag = TRUE
  api = if(is.null(api))
    api = Sys.getenv("typeform_api")
  if(nchar(api) == 0) api_flag = FALSE

  forms = NULL
  is_form = FALSE
  if(api_flag){
    forms = formlist_attempt(api)
    is_form = is_formlist(forms)
  }

  ui = miniPage(
    gadgetTitleBar("Typeform Responses"),
    miniContentPanel(uiOutput("ui"))
  )

  server = function(input,output,session){

    rvs = reactiveValues(
      api_flag = api_flag,
      api = api,
      forms = forms,
      is_form = is_form
    )
    output$ui = renderUI({
      ## 3 cases to take care of,
      ## 1) no api key
      ## 2) bad api key
      ## 3) good key, forms returned

      ## 1)
      if(!rvs$api_flag){ ## show a text box for api key
        return(div(
          wellPanel(
            textInput("api_key", "Please enter an API key")
          ),
          miniButtonBlock(
            actionButton("api_submit", "Submit")
          )
        ))
      }

      ## 2)
      else if(!rvs$is_form){
          div(
            h2("The provided api key did not give a suitable response.") , br(),
            wellPanel(
              textInput("api_key", "Please enter an API key")
            ),
            miniButtonBlock(
              actionButton("api_submit", "Submit")
            )
          )
      }

      ## 3)
      else{
        div(

          p("Choose a questionnaire and a name to assign it to. Click done in the top right
                               to put put the code into the editor."),
          fillRow(
            wellPanel(
              selectInput("form_select",label = "Typeform questionnaires",
                          choices = rvs$forms$content$name)
            ),
            wellPanel(
              textInput("qname", label = "Variable name", value = "tform")
            )
          )#,
          # selectInput("completed_par", "Completed", choices = c("All","Completed","Uncompleted"))

        )
      }
    })


    observeEvent(input$api_submit,{
      api = input$api_key
      forms = formlist_attempt(api)
      is_form = is_formlist(forms)

      if(!is_form){ ## if not a form, means an error, likely invalid key
        showModal(modalDialog(title = "Error",
                              p("The request generated an error",br(), forms$message)))
      }else{
        #if correct, update the apiflag and value
        rvs$api = api
        rvs$api_flag = TRUE
        rvs$forms = forms
        rvs$is_form = is_form
      }
    })

    observeEvent(input$done,{
      if(rvs$is_form){
        rstudioapi::insertText(text = paste0(input$qname, ' = get_questionnaire(uid = "',
                                             rvs$forms$content$uid[rvs$forms$content$name == input$form_select],
                                             '", api = "', rvs$api, '")'))
      }
      stopApp()
    })
  }

  viewer = paneViewer(300)
  runGadget(ui,server,viewer = viewer)
}

formlist_attempt = function(api){
  tryCatch(get_typeforms(api), error = function(e) e)
}

is_formlist = function(typeform){
  if(inherits(typeform, "rtypeform_all")) return(TRUE)
  else FALSE # implies that it is an error
}
