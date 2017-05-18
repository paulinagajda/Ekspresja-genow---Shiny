# Ekspresja genów ludzkich - Shiny

# 15.05.2017
Na wejściu użytkownik wprowadza nazwę genu. Aplikacja tworzy wykres przedstawiający ekspresję genów w różnych tkankach.

Pliki baz danych pochodzą ze stron:
http://biogps.org/downloads/ (Human U133A/GNF1H Gene Atlas) (dane1)
https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GPL96 (Tabela z ponad 33 000 najlepiej scharakteryzowanymi genami ludzkimi. Sekwencje zostały wybrane z GenBank, dbEST i RefSeq) (dane2)

# 18.05.2017
Przy pobraniu bazy danych ze strony ncbi pojawił się problem z wczytaniem danych - brak separtorów, które R mógłby zczytać. Plik został następnie pobrany w rozszerzeniu .annot i mimo wyskakujących błędów otworzony przez programem Microsoft Excel, w którym został zapisany jako .csv (dane2) z separatorami ",".

Wstępna analiza danych pozwoliła mi na wybór 10 miejsc (serce, nerki , wątroba, płuca , przysadka, tarczyca, język, macica, krew, mózg;  dane<-dane1[,c(1,34,36,40,41,52,72,73,77,79,80)]), w których następuje ekspresja genów. Zostaną one przedstawione na wykresie. 

W pętli został utworzony wektor w=c(w, dane[,i][dane$X==(dane2$ID[dane2$Gene.symbol=="input$gen"]) oraz macierz geny<-matrix(w, 1, 10, dimnames=list(c("Ekspresja"),c("Serce", "Nerki", "Wątroba", "Płuca", "Przysadka", "Tarczyca", "Język", "Macica", "Krew", "Mózg"))), które pozwolą mi na stworzenie wykresu (barplot).


___________________________________________________________________________________
Dodatkowo można poszukac skorelowanych genów lub genów występujących w danej tkance.
