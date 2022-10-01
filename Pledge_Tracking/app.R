
library(shiny)
library(readr)
library(dplyr)
library(DT)


ui <- fluidPage(
  
  titlePanel("Pledge Tracking App"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("pledges_data", "Upload pledges data", accept = ".csv"),
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
  
  
  pledges <- reactive({
    
    input$pledges_data
    
    
  })
  
  actblue <- reactive({
    
    input$actblue_data
    
    
  })
  
  pledge_tracking <- reactive({
    pledges_df <- read_csv(pledges()$datapath)
    actblue_df <- read_csv(actblue()$datapath)
    
    ## convert column names to uppercase to avoid errors
    
    names(pledges_df) <- toupper(names(pledges_df))
    names(actblue_df) <- toupper(names(actblue_df))
    
    ## convert string data to uppercase
    
    pledges_upper <- data.frame(lapply(pledges_df,
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
    
    pledge_tracking <- inner_join(pledges_upper, actblue_upper, 
                                  by=c("FIRST.NAME"="DONOR.FIRST.NAME",
                                       "LAST.NAME"="DONOR.LAST.NAME"))
  })
  
  
  
  
  output$preview <- renderDT({
    
    if (is.null(input$pledges_data) | is.null(input$actblue_data))
      return(NULL)
    
    pledge_tracking()
    
  })
  
  
  output$downloadData <- downloadHandler(
    filename = "pledge_tracking.csv",
    content = function(file) {
      write.csv(pledge_tracking(), file)
    }
  )
  
  
  
}

shinyApp(ui = ui, server = server)
