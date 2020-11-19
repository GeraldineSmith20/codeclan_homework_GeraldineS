library(shiny)
library(dplyr)
library(ggplot2)
library(shinythemes)
library(CodeClanData)

all_teams <- unique(olympics_overall_medals$team)

ui <- fluidPage(
  theme = "shiny_example_style.css",
  titlePanel(tags$h1("Olympic Medals")),
  fluidRow(
    column(6,
           radioButtons("season",
                        tags$i("Summer or Winter Olympics?"),
                        choices = c("Summer", "Winter")
           )
    ),
    column(6,
           selectInput("medal",
                       "Which medal?",
                       choices = c("Bronze", "Silver", "Gold")
    )
  ),
  plotOutput("medal_plot"),
)
)
server <- function(input, output) {
  output$medal_plot <- renderPlot({
    olympics_overall_medals %>%
      filter(team %in% c("United States",
                         "Soviet Union",
                         "Germany",
                         "Italy",
                         "Great Britain")) %>%
      filter(medal == input$medal) %>%
      filter(season == input$season) %>%
      ggplot() +
      aes(x = team, y = count) +
      geom_col()
  })
}
shinyApp(ui = ui, server = server)