require(shiny)
library(datasets)
require("RCurl")
library("RColorBrewer")


myfile <-getURL("https://raw.githubusercontent.com/paulinagajda/Ekspresja-genow---Shiny/master/U133AGNF1B.gcrma.avg.csv", ssl.verifyhost=FALSE, ssl.verifypeer=FALSE)
dane=read.table(textConnection(myfile), header = TRUE, sep=",", colClasses = "character")
myfile <-getURL("https://raw.githubusercontent.com/paulinagajda/Ekspresja-genow---Shiny/master/dane2.csv", ssl.verifyhost=FALSE, ssl.verifypeer=FALSE)
dane2=read.table(textConnection(myfile), header = TRUE, sep=";", colClasses = "character")
rm(myfile)
dane=dane[,c(1,34,36,40,41,52,72,73,77,79,80)]

#Porz�dkowanie danych:
sum(dane$X %in% dane2$ID) #tyle gen�W z pliku dane jest w pliku dane2
x=which(!(dane$X %in% dane2$ID)) #te wiersze s� w dane1 i nie ma ich w dane2
dane=dane[-x,] #tu je usuwamy
rm(x) #zwalniam przestrze� robocz�
any(duplicated(dane$X)) #sprawdzam czy co� si� powtarza w dane, ale nie
any(duplicated(dane2$ID)) #ale w dane 2 wi�c go usuniemy
x=which(duplicated(dane2$ID))
dane2=dane2[-x,]
rm(x) #zwalniam przestrze�
all(dane$X==dane2$ID) #FALSE wi�c s� w innej kolejno�ci wi�c b�d� chcia�a tak samo posortowa�
dane2=dane2[order(match(dane2$ID, dane$X)),] #sortuj�
all(dane2$ID==dane$X) #TRUE wi�c ju� ok
dane$Gen.symbol=dane2$Gene.symbol #�eby mie� tylko jedn� tabelk�
dane=dane[,c(1,12,2,3,4,5,6,7,8,9,10,11)] #zmieniam kolejno�� bo tak �adniej ;)
colnames(dane)=c("ID", colnames(dane)[2:12])
rm(dane2) #usuwam ju� niepotrzebne
x=which(duplicated(dane$Gen.symbol)) #usuwam pow�rki w gen.symbol
dane=dane[-x,]
rm(x)

#ODT�D URUCHAMIAM
ui<-fluidPage(    
  titlePanel("Podaj nazw� genu"),
  sidebarLayout(      
    sidebarPanel(
      selectInput("gen", "Wybierz gen:", choices = dane$Gen.symbol),
      hr(),
      helpText("Na wej�ciu u�ytkownik wybiera nazw� genu. Aplikacja tworzy wykres przedstawiaj�cy ekspresj� tego genu w r�nych tkankach.")
    ),
    mainPanel(
      plotOutput("gen_plot")  
    )
  )
)

server<-function(input, output) {
  output$gen_plot <- renderPlot({
    for (i in 1:length(dane$ID)){
      if (input$gen==dane$Gen.symbol[i]) x=i
    }
    geny<-matrix(dane[x,3:12], 1, 10, dimnames=list(c("Ekspresja"),c("Heart","Kidney", "Liver", "Lung", "Pituitary", "Thyroid", "Tongue", "Uterus", "WholeBlood", "Wholebrain")))
    
    barplot(geny, cex.names=0.75, col=heat.colors(10),  horiz = T, las=1) #tu podaje dane jakie b�d� wy�wietlane - musz� mie� ekspresj� dla danej tkanki
    
    
  })
}

shinyApp(ui, server)

