# Ekspresja genów ludzkich - Shiny

# 15.05.2017
Na wejściu użytkownik wprowadza nazwę genu. Aplikacja tworzy wykres przedstawiający ekspresję genów w różnych tkankach.

Pliki baz danych pochodzą ze stron:
http://biogps.org/downloads/ (Human U133A/GNF1H Gene Atlas) (dane)
https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GPL96 (Tabela z ponad 33 000 najlepiej scharakteryzowanymi genami ludzkimi. Sekwencje zostały wybrane z GenBank, dbEST i RefSeq) (dane2)

# 18.05.2017
Przy pobraniu bazy danych ze strony ncbi pojawił się problem z wczytaniem danych - brak separtorów, które R mógłby zczytać. Plik został następnie pobrany w rozszerzeniu .annot i mimo wyskakujących błędów otworzony przez programem Microsoft Excel, w którym został zapisany jako .csv (dane2) z separatorami ",".

Wstępna analiza danych pozwoliła mi na wybór 10 miejsc (serce, nerki , wątroba, płuca , przysadka, tarczyca, język, macica, krew, mózg;  za pomocą: dane<-dane1[,c(1,34,36,40,41,52,72,73,77,79,80)]),
w których następuje ekspresja genów. Zostaną one przedstawione na wykresie. 


W pętli został utworzony wektor (i in 2:11) w=c(w, dane[,i][dane$X==(dane2$ID[dane2$Gene.symbol=="input$gen"]) 
oraz macierz geny<-matrix(w, 1, 10, dimnames=list(c("Ekspresja"),c("Serce", "Nerki", "Wątroba", "Płuca", "Przysadka", "Tarczyca", "Język", "Macica", "Krew", "Mózg"))), które pozwolą mi na stworzenie wykresu (barplot).

# 21.05.2017 / 22.05.2017
1. Usunięto geny, które występują w pliku dane a nie ma ich w pliku dane2.
sum(dane$X %in% dane2$ID) 
x=which(!(dane$X %in% dane2$ID))
dane=dane[-x,]

2. Usunięto powtórki z dane2 (brak powtórek w dane)
any(duplicated(dane2$ID)) 
x=which(duplicated(dane2$ID))
dane2=dane2[-x,]

3. Posortowano dane2 wg. ID (wstępne przygotowanie do stworzenia jednej tabeli)
all(dane$X==dane2$ID)
dane2=dane2[order(match(dane2$ID, dane$X)),] 
all(dane2$ID==dane$X)

4. Utworzono jedną tabelę zawierającą ID genu, jego symbol oraz ekspresję w danych tkankach (ułożone alfabetycznie)
dane$Gen.symbol=dane2$Gene.symbol
dane=dane[,c(1,12,2,3,4,5,6,7,8,9,10,11)]
colnames(dane)=c("ID", colnames(dane)[2:12])

5. Usunięto powtórki w dane (Gen.symbol)
x=which(duplicated(dane$Gen.symbol))
dane=dane[-x,]
rm(x)

6. Zmieniono wektor w oraz zmodyfikowano macierz, powrócono do angielskiego nazewnictwa.
for (i in 1:length(dane$ID)){if (input$gen==dane$Gen.symbol[i]) x=i}
geny<-matrix(dane[x,3:12], 1, 10, dimnames=list(c("Ekspresja"),c("Heart","Kidney", "Liver", "Lung", "Pituitary", "Thyroid", "Tongue", "Uterus", "WholeBlood", "Wholebrain")))

