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

#Porz¹dkowanie danych:
sum(dane$X %in% dane2$ID) #tyle genóW z pliku dane jest w pliku dane2
x=which(!(dane$X %in% dane2$ID)) #te wiersze s¹ w dane1 i nie ma ich w dane2
dane=dane[-x,] #tu je usuwamy
rm(x) #zwalniam przestrzeñ robocz¹
any(duplicated(dane$X)) #sprawdzam czy coœ siê powtarza w dane, ale nie
any(duplicated(dane2$ID)) #ale w dane 2 wiêc go usuniemy
x=which(duplicated(dane2$ID))
dane2=dane2[-x,]
rm(x) #zwalniam przestrzeñ
all(dane$X==dane2$ID) #FALSE wiêc s¹ w innej kolejnoœci wiêc bêdê chcia³a tak samo posortowaæ
dane2=dane2[order(match(dane2$ID, dane$X)),] #sortujê
all(dane2$ID==dane$X) #TRUE wiêc ju¿ ok
dane$Gen.symbol=dane2$Gene.symbol #¿eby mieæ tylko jedn¹ tabelkê
dane=dane[,c(1,12,2,3,4,5,6,7,8,9,10,11)] #zmieniam kolejnoœæ bo tak ³adniej ;)
colnames(dane)=c("ID", colnames(dane)[2:12])
rm(dane2) #usuwam ju¿ niepotrzebne
x=which(duplicated(dane$Gen.symbol)) #usuwam powórki w gen.symbol
dane=dane[-x,]
rm(x)

#ODT¥D URUCHAMIAM
ui<-fluidPage(    
  titlePanel("Podaj nazwê genu"),
  sidebarLayout(      
    sidebarPanel(
      selectInput("gen", "Wybierz gen:", choices = dane$Gen.symbol),
      hr(),
      helpText("Na wejœciu u¿ytkownik wybiera nazwê genu. Aplikacja tworzy wykres przedstawiaj¹cy ekspresjê tego genu w ró¿nych tkankach.")
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
    
    barplot(geny, cex.names=0.75, col=heat.colors(10),  horiz = T, las=1) #tu podaje dane jakie bêd¹ wyœwietlane - muszê mieæ ekspresjê dla danej tkanki
    
    
  })
}

shinyApp(ui, server)

