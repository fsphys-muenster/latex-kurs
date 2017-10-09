# Einstellungen
set terminal tikz solid size 15,9
#set terminal wxt size 1500,900
set decimalsign locale "de_DE.UTF8" # Werte mit Komma als Dezimal-Separator einlesen
set decimalsign ','                 # Dezimalbrüche mit Komma ausgeben
set mxtics
set mytics
set key bmargin
set key spacing 1.9
set fit quiet errorvariables
#set samples 200

set pointsize 0.2


# Auswertung
f(x) = m * x + b
h(x) = m2 * x + b2
g(x) = a_0 + a_1 * x + a_2 * x**2.


### Nr. 2 (Kühlleistung)
set xrange [:800]
set yrange [-25:25]
set output "Kuehlleistung.tex"
set xlabel "Zeit $t$ in \\si{\\s}"
set ylabel "Temperatur $T$ in \\si{\\celsius}"  
fit [18:24.2] f(x) "messwerte/abkühlung (nr. 2).txt" using 1:2 via m, b 
fit [156:164.6] h(x) "" using 1:2 via m2, b2
plot "messwerte/abkühlung (nr. 2).txt" using 1:2 notitle, \
	f(x) title sprintf("Ausgleichsgerade (Raumtemperatur): $(\\num{%.3g}) x + (\\num{%.3g})$", m, b), \
	h(x) title sprintf("Ausgleichsgerade für Schmelzwärme: $(\\num{%.3g}) x + (\\num{%.3g})$", m2, b2)
print "m = ",m, " +- ", m_err,  " b = ",b, " +- ", b_err




### Nr. 3 (Heizleistung)
set xrange [:420]
set yrange [-25:60]
set output "Heizleistung.tex"
set xlabel "Zeit $t$ in \\si{\\s}"
set ylabel "Temperatur $T$ in \\si{\\celsius}"
fit [:] [-10:-8] h(x) "messwerte/erhitzung (nr. 3).txt" using 1:2 via m2, b2
fit [:] [20:21] f(x) "" using 1:2 via m, b
plot "messwerte/erhitzung (nr. 3).txt" using 1:2 notitle, \
	f(x) title sprintf("Ausgleichsgerade (Raumtemperatur): $(\\num{%.3g}) x + (\\num{%.3g})$", m, b), \
	h(x) title sprintf("Ausgleichsgerade für $c_E$: $(\\num{%.3g}) x + (\\num{%.3g})$", m2, b2)
print "m = ",m, " +- ", m_err,  " b = ",b, " +- ", b_err

set autoscale

load("nr4.gp")

# Einstellungen zurücksetzen
set terminal tikz solid size 14,9
#set terminal wxt size 1500,900
set key spacing 1.9
set autoscale

# Nr. 5 (Pronyscher Zaum)
set yrange [0:0.1]
eta(P, P_el) = P/P_el
delta_eta(P, P_el, Delta_P, Delta_P_el) = sqrt(Delta_P_el**2.*P**2./P_el**4. + Delta_P**2./P_el**2.)
P_el(U, I) = U * I
delta_P_el(U, I, Delta_U, Delta_I) = sqrt(Delta_U**2.*I**2. + Delta_I**2.*U**2.)
P(F, f, r) = 2 * pi * f * F * r
delta_P(F, f, r, Delta_F, Delta_f, Delta_r) = sqrt(4.*pi**2.*Delta_r**2.*F**2.*f**2. + 4.*pi**2.*Delta_f**2.*F**2.*r**2. + 4.*pi**2.*Delta_F**2.*f**2.*r**2.)
r = 0.5	# m
P_el_ = P_el(14.6, 0.048*1000./3.)
delta_P_el_ = delta_P_el(14.6, 0.048*1000./3., 0.2, 1./3.)
set output "prony.tex"
set xlabel "Frequenz $f$ in \\si{\\Hz}"
set ylabel "Wirkungsgrad $\\eta$"
fit g(x) "prony.csv" using 2:( eta(P($1, $2, r), P_el_) ):\
	( delta_eta(P($1, $2, r), P_el_, delta_P($1, $2, r, 0.1, $3, 0.001), delta_P_el_) ) \
	via a_0, a_1, a_2
plot "" using 2:( eta(P($1, $2, r), P_el_) ):\
	3:( delta_eta(P($1, $2, r), P_el_, delta_P($1, $2, r, 0.1, $3, 0.001), delta_P_el_) ) \
	title "Messwerte" with xyerrorbars, \
	g(x) title sprintf("Ausgleichskurve: $(\\num{%.3g}) + (\\num{%.3g}) x + (\\num{%.3g}) x^2$", a_0, a_1, a_2)


