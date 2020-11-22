library(shiny)
library(tidyverse)
library(shinythemes)

#read in data

library(tidyverse)
library(janitor)
library(ggplot2)
cancer_data <- read_csv("data/nhs_cancer_incidence.csv") %>% 
  clean_names() %>% 
  select(cancer_site, sex, year, incidences_age_under5:incidences_age90and_over) %>% 
  pivot_longer(incidences_age_under5:incidences_age90and_over, names_to = "age", values_to = "incidences") %>% 
  filter(sex != "All",
         cancer_site != "All cancer types") %>% 
  mutate(age = str_remove(age, "incidences_age")) %>% 
  mutate(age = str_replace(age, "_under", "Under ")) %>% 
  mutate(age = str_replace(age, "to", " to ")) %>% 
  mutate(age = str_replace(age, "and_", " and ")) %>% 
  mutate(age = factor(age, levels = c("Under 5", "5 to 9", "10 to 14", 
                                      "15 to 19", "20 to 24", "25 to 29",
                                      "30 to 34", "35 to 39", "40 to 44",
                                      "45 to 49", "50 to 54", "55 to 59",
                                      "60 to 64", "65 to 69", "70 to 74",
                                      "75 to 79", "80 to 84", "85 to 89",
                                      "90 and over")))

age_choices <- cancer_data %>% 
  distinct(age) %>% 
  pull()

cancer_site_choices <- cancer_data %>% 
  distinct(cancer_site) %>% 
  arrange(cancer_site) %>% 
  pull()


# define ui

ui <- fluidPage(theme = shinytheme("cosmo"),
  
  titlePanel("NHS Scotland Annual Cancer Incidence"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "age",
                  label = "Age Range",
                  choices = age_choices),
      
      selectInput(inputId = "cancer_site",
                  label = "Cancer Type",
                  choices = cancer_site_choices),
      
      actionButton(inputId = "update",
                   label = "Show plot and table")
      
      ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Plot",
                 plotOutput("plot")),
        tabPanel("Data",
                 dataTableOutput("table")))
      )
      
    )
  )


# define server

server <- function(input, output){
  
  filtered_stats <- eventReactive(input$update, {
    cancer_data %>% 
      filter(age == input$age) %>% 
      filter(cancer_site == input$cancer_site)
  })
  
  output$plot <- renderPlot({
    filtered_stats() %>% 
      ggplot() +
      aes(x = year, y = incidences, fill = sex) +
      geom_col() +
      facet_wrap(~ sex, ncol = 1) +
      labs(x = "Year",
           y = "No. of Cases") +
      theme(axis.text.x = element_text(face = "bold", 
                                       size = 12,
                                       vjust = 0.5,
                                       angle = 45),
            axis.text.y = element_text(face = "bold", 
                                       size = 12))
  })
  
  output$table <- renderDataTable({
    filtered_stats() 
    
  })

}

shinyApp(ui = ui, server = server)



