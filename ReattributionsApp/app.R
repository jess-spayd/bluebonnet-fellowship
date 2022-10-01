
library(shiny)
library(readr)
library(dplyr)
library(DT)
library(fuzzyjoin)


ui <- fluidPage(
  
  titlePanel("Reattributions App"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("phoneburner_data", "Upload PhoneBurner data", accept = ".csv"),
      fileInput("actblue_data", "Upload ActBlue data", accept = ".csv"),
      strong("Instructions:"), "Upload BOTH files to see the preview on the right. 
      Then, click the download button (above the preview) to save the report."

    ),
    mainPanel(downloadButton("downloadData", "Click to download report"),
              h3("Preview"),
              DTOutput("preview")

    )
  )
)

server <- function(input, output, session) {
  
  
  calltime <- reactive({
    
    input$phoneburner_data

    
  })
  
  actblue <- reactive({
    
    input$actblue_data

    
  })
  

  
  reattributions <- reactive({
    
    ## read files
    
    calltime_df <- read_csv(calltime()$datapath)
    actblue_df <- read_csv(actblue()$datapath)
    
    ## convert column names to uppercase to avoid errors
    
    names(calltime_df) <- toupper(names(calltime_df))
    names(actblue_df) <- toupper(names(actblue_df))
    
    ## convert string data to uppercase
    
    calltime_upper <- data.frame(lapply(calltime_df,
                                        function(variables) {
                                          if (is.character(variables)) {
                                            return(toupper(variables))
                                          } else {
                                            return(variables)
                                          }
                                        }),
                                 stringsAsFactors = FALSE)
    
    actblue_upper <- data.frame(lapply(actblue_df,
                                        function(variables) {
                                          if (is.character(variables)) {
                                            return(toupper(variables))
                                          } else {
                                            return(variables)
                                          }
                                        }),
                                 stringsAsFactors = FALSE)
    
    ## inner join on first & last names
    
#    require(fuzzyjoin)
 #   reattributions <- regex_inner_join(calltime_df, actblue_df, 
  #                   by=c("FIRST NAME"="DONOR FIRST NAME",
   #                  "LAST NAME"="DONOR LAST NAME", 
    #                 ignore_case = TRUE))
    
    reattributions <- inner_join(calltime_upper, actblue_upper, 
                                 by=c("FIRST.NAME"="DONOR.FIRST.NAME",
                                      "LAST.NAME"="DONOR.LAST.NAME"))

#### Selecting columns caused issues because the names are not consistent
        
#    reattributions <- select(reattributions, 
 #                            ## call time columns
  #                           "VANID", "FIRST NAME", "LAST NAME",
   #                          "EMAIL", "PHONE", "NOTES", "LAST CALL", "STATUS",
    #                         "PLEDGE", 
     #                        "MONEY IN",
      #                       ## act blue columns
       #                      "DATE", "AMOUNT", 
        #                     "DONOR EMAIL", "DONOR PHONE",
         #                    "FUNDRAISING PAGE", "REFERENCE CODE")
  })
  


  
  output$preview <- renderDT({     ### DT = interactive table!
    
    ## do not render if both files are not uploaded
    
    if (is.null(input$phoneburner_data) | is.null(input$actblue_data))
      return(NULL)

    ## display the joined tables in DT
    
    reattributions()
    
  })

  ### download button
  
  output$downloadData <- downloadHandler(
    filename = "reattributions.csv",
    content = function(file) {
      write.csv(reattributions(), file)
    }
  )

  

}

shinyApp(ui = ui, server = server)
