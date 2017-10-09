# Gitter und Zwischenmarkierungen
# einzeichnen
set grid; set mxtics; set mytics
# Komma als Dezimalseparator ausgeben
set decimalsign ","

# Im x-Intervall [2.1; 11] zeichnen
set xrange [2.1:11]
# Text für x- und y-Achse
set xlabel "Winkel [rad]"
set ylabel "Intensität [a.u.]"

# Ausgabeformat und -Ort
set terminal pdf
set output "beispiel.pdf"

# Funktion mit Legende zeichen
plot sin(x)**2/x**2 title "Beugungsmuster"
