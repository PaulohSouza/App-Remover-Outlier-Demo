
library(shiny)
library(ggplot2) 


ui <- fluidPage(
  h4("Remover outlier App - Teste com base pública mtcars [Paulo H N Souza]"),
  

  plotOutput(outputId = "boxplot", brush = "plot_brush_"), 
  
  fixedRow(
    
    column(width= 5, tags$b(tags$i("Base de dados Atual")),  tableOutput("data1")),
    column(width = 5, tags$b(tags$i("Base de dados atualizada")), tableOutput("data2"), offset = 2)
  )
  
  
  
)


server <- function(input, output) {
  
  mtcars1 = mtcars
  mtcars1$cyl = as.factor(mtcars1$cyl)
  mt <- reactiveValues(data=mtcars1) 
  
  

  output$boxplot <- renderPlot({
    ggplot(mt$data, aes(cyl, mpg)) + geom_boxplot(outlier.colour = "red") + coord_flip()

  })
  
  output$data1 <- renderTable({
    mtcars1
  })
  

  output$data2 <- renderTable({
    mt$data 
  })
  
  
  observe({
    df = brushedPoints(mt$data, brush = input$plot_brush_, allRows = TRUE) 
    mt$data = df[df$selected_== FALSE,  ] 
    
    
  })
  
}


shinyApp(ui = ui, server = server)
         