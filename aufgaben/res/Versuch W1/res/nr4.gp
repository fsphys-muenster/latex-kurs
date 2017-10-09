set terminal tikz solid size 15.5,20
set key spacing 3.3
set xlabel "Volumen $V$ in \\si{\\cm^3}"
set ylabel "Druck $p$ in \\si{\\kPa}"
# every ::10::100   => plot from line 10 to line 100

#Volumen(phi, phi_min, delta_phi)= \
#	V_min-sin((phi+phi_min)*pi/delta_phi-pi/2.)*V_plus
Volumen(phi, phi_min, phi_max) = \
	(V_max - V_min)/(phi_min - phi_max) * phi + V_max - (V_max - V_min)/(phi_min - phi_max) * phi_min
fit_choose_above(phi, p, phi_min, phi_max, a, b) = p > iso_p(Volumen(phi, phi_min, phi_max), a, b) ? p : 1/0
fit_choose_below(phi, p, phi_min, phi_max, a, b) = p < iso_p(Volumen(phi, phi_min, phi_max), a, b) ? p : 1/0
V_min = 195.
V_max = 195. + 140.

isotherm(x) = a/x + b
iso_p(x, a, b) = a/x + b

poly_p(x, a0, a1, a2, a3, a4, a5, a6) = a0 + a1 * x + a2 * x**2. + a3 * x**3. + a4 * x**4. + a5 * x**5. + a6 * x**6.
poly1(x) = poly_p(x, a0, a1, a2, a3, a4, a5, a6)
poly2(x) = poly_p(x, b0, b1, b2, b3, b4, b5, b6)
poly_int(x, a0, a1, a2, a3, a4, a5, a6) = a0 * x + a1 / 2. * x**2. + a2 / 3. * x**3. + a3 / 4. * x**4. + a4 / 5. * x**5. + a5 / 6. * x**6.  + a6 / 7. * x**7.


temp1(phi, p) = Volumen(phi, phi_min, phi_max) < 210 \
		? fit_choose_above(phi, p, phi_min, phi_max, a, b) + shift \
		: fit_choose_above(phi, p, phi_min, phi_max, a, b)
temp2(phi, p) = Volumen(phi, phi_min, phi_max) < 210 \
		? fit_choose_below(phi, p, phi_min, phi_max, a, b) + shift \
		: fit_choose_below(phi, p, phi_min, phi_max, a, b)

frmt = "(\\num{%.3g}) + (\\num{%.3g}) x + (\\num{%.3g}) x^2$\\\\$ + (\\num{%.3g}) x^3 + (\\num{%.3g}) x^4 + (\\num{%.3g}) x^5 + (\\num{%.3g}) x^6$}"
frmt_top = "\\protect\\shortstack[r]{Approximation obere Hälfte: $f(x) = " . frmt
frmt_bottom = "\\protect\\shortstack[r]{Approximation untere Hälfte: $g(x) = " . frmt

set xrange [190:340]
set yrange [90:220]


### Nr. 4 (8v p,v)
set output "8V-p,v.tex"
phi_min = -0.335
phi_max = 1.684
fit isotherm(x) "messwerte/nr.4 8v p,v.txt" every 2 using (Volumen($1, phi_min, phi_max)):2 via a, b
b = b + 1.1
fit poly1(x) "" using (Volumen($1, phi_min, phi_max)):(fit_choose_above($1, $2, phi_min, phi_max, a, b)) via a0, a1, a2, a3, a4, a5, a6
fit poly2(x) "" using (Volumen($1, phi_min, phi_max)):(fit_choose_below($1, $2, phi_min, phi_max, a, b)) via b0, b1, b2, b3, b4, b5, b6
plot "" every ::::2000 using (Volumen($1, phi_min, phi_max)):2 title "Messwerte", \
	iso_p(x, a, b) title "Trennkurve", \
	poly_p(x, a0, a1, a2, a3, a4, a5, a6) title sprintf(frmt_top, a0, a1, a2, a3, a4, a5, a6), \
	poly_p(x, b0, b1, b2, b3, b4, b5, b6) title sprintf(frmt_bottom, b0, b1, b2, b3, b4, b5, b6) linestyle 5
print "8V"
print "a0 = ", a0, "; a1 = ", a1, "; a2 = ", a2, "; a3 = ", a3, "; a4 = ", a4, "; a5 = ", a5, "; a6 = ", a6
print "b0 = ", b0, "; b1 = ", b1, "; b2 = ", b2, "; b3 = ", b3, "; b4 = ", b4, "; b5 = ", b5, "; b6 = ", b6
print "I1 = ", poly_int(V_max, a0, a1, a2, a3, a4, a5, a6) - poly_int(V_min, a0, a1, a2, a3, a4, a5, a6)
print "I2 = ", poly_int(V_max, b0, b1, b2, b3, b4, b5, b6) - poly_int(V_min, b0, b1, b2, b3, b4, b5, b6)
print ""


### Nr. 4 (10v p,v)
set output "10V-p,v.tex"
phi_min = -2.015
phi_max = 0.006
fit isotherm(x) "messwerte/nr.4 10v p,v.txt" every 2 using (Volumen($1, phi_min, phi_max)):2 via a, b
b = b + 1.3
shift = 0.45
fit poly1(x) "" using (Volumen($1, phi_min, phi_max)):(temp1($1, $2)) via a0, a1, a2, a3, a4, a5, a6
fit poly2(x) "" using (Volumen($1, phi_min, phi_max)):(temp2($1, $2)) via b0, b1, b2, b3, b4, b5, b6
plot "" every ::::2000 using (Volumen($1, phi_min, phi_max)):2 title "Messwerte", \
	x < 210 ? iso_p(x, a, b) + shift : iso_p(x, a, b) title "Trennkurve", \
	poly_p(x, a0, a1, a2, a3, a4, a5, a6) title sprintf(frmt_top, a0, a1, a2, a3, a4, a5, a6), \
	poly_p(x, b0, b1, b2, b3, b4, b5, b6) title sprintf(frmt_bottom, b0, b1, b2, b3, b4, b5, b6) linestyle 5
print "10V"
print "a0 = ", a0, "; a1 = ", a1, "; a2 = ", a2, "; a3 = ", a3, "; a4 = ", a4, "; a5 = ", a5, "; a6 = ", a6
print "b0 = ", b0, "; b1 = ", b1, "; b2 = ", b2, "; b3 = ", b3, "; b4 = ", b4, "; b5 = ", b5, "; b6 = ", b6
print "I1 = ", poly_int(V_max, a0, a1, a2, a3, a4, a5, a6) - poly_int(V_min, a0, a1, a2, a3, a4, a5, a6)
print "I2 = ", poly_int(V_max, b0, b1, b2, b3, b4, b5, b6) - poly_int(V_min, b0, b1, b2, b3, b4, b5, b6)
print ""


#### Nr. 4 (12v p,v)
set output "12V-p,v.tex"
phi_min = -1.704
phi_max = 0.327
fit isotherm(x) "messwerte/nr.4 12v p,v.txt" every 2 using (Volumen($1, phi_min, phi_max)):2 via a, b
a = a
b = b + 1.3
shift = 1.0
fit poly1(x) "" using (Volumen($1, phi_min, phi_max)):(temp1($1, $2)) via a0, a1, a2, a3, a4, a5, a6
fit poly2(x) "" using (Volumen($1, phi_min, phi_max)):(temp2($1, $2)) via b0, b1, b2, b3, b4, b5, b6
plot "" every ::::2000 using (Volumen($1, phi_min, phi_max)):2 title "Messwerte", \
	x < 210 ? iso_p(x, a, b) + shift : iso_p(x, a, b) title "Trennkurve", \
	poly_p(x, a0, a1, a2, a3, a4, a5, a6) title sprintf(frmt_top, a0, a1, a2, a3, a4, a5, a6), \
	poly_p(x, b0, b1, b2, b3, b4, b5, b6) title sprintf(frmt_bottom, b0, b1, b2, b3, b4, b5, b6) linestyle 5
print "12V"
print "a0 = ", a0, "; a1 = ", a1, "; a2 = ", a2, "; a3 = ", a3, "; a4 = ", a4, "; a5 = ", a5, "; a6 = ", a6
print "b0 = ", b0, "; b1 = ", b1, "; b2 = ", b2, "; b3 = ", b3, "; b4 = ", b4, "; b5 = ", b5, "; b6 = ", b6
print "I1 = ", poly_int(V_max, a0, a1, a2, a3, a4, a5, a6) - poly_int(V_min, a0, a1, a2, a3, a4, a5, a6)
print "I2 = ", poly_int(V_max, b0, b1, b2, b3, b4, b5, b6) - poly_int(V_min, b0, b1, b2, b3, b4, b5, b6)
print ""


#### Nr. 4 (14v p,v)
set output "14V-p,v.tex"
phi_min = -0.066
phi_max = 1.967
fit isotherm(x) "messwerte/nr.4 14v p,v.txt" every 2 using (Volumen($1, phi_min, phi_max)):2 via a, b
a = a
b = b + 1.1
shift = 1.0
fit poly1(x) "" using (Volumen($1, phi_min, phi_max)):(temp1($1, $2)) via a0, a1, a2, a3, a4, a5, a6
fit poly2(x) "" using (Volumen($1, phi_min, phi_max)):(temp2($1, $2)) via b0, b1, b2, b3, b4, b5, b6
plot "" every ::::6000 using (Volumen($1, phi_min, phi_max)):2 title "Messwerte", \
	x < 210 ? iso_p(x, a, b) + shift : iso_p(x, a, b) title "Trennkurve", \
	poly_p(x, a0, a1, a2, a3, a4, a5, a6) title sprintf(frmt_top, a0, a1, a2, a3, a4, a5, a6), \
	poly_p(x, b0, b1, b2, b3, b4, b5, b6) title sprintf(frmt_bottom, b0, b1, b2, b3, b4, b5, b6) linestyle 5
print "14V"
print "a0 = ", a0, "; a1 = ", a1, "; a2 = ", a2, "; a3 = ", a3, "; a4 = ", a4, "; a5 = ", a5, "; a6 = ", a6
print "b0 = ", b0, "; b1 = ", b1, "; b2 = ", b2, "; b3 = ", b3, "; b4 = ", b4, "; b5 = ", b5, "; b6 = ", b6
print "I1 = ", poly_int(V_max, a0, a1, a2, a3, a4, a5, a6) - poly_int(V_min, a0, a1, a2, a3, a4, a5, a6)
print "I2 = ", poly_int(V_max, b0, b1, b2, b3, b4, b5, b6) - poly_int(V_min, b0, b1, b2, b3, b4, b5, b6)
print ""


#### Nr. 4 (16v p,v)
set output "16V-p,v.tex"
phi_min = -0.759
phi_max = 1.28
fit isotherm(x) "messwerte/nr.4 16v p,v.txt" every 2 using (Volumen($1, phi_min, phi_max)):2 via a, b
a = a
b = b + 1.1
shift = 2.0
fit poly1(x) "" using (Volumen($1, phi_min, phi_max)):(temp1($1, $2)) via a0, a1, a2, a3, a4, a5, a6
fit poly2(x) "" using (Volumen($1, phi_min, phi_max)):(temp2($1, $2)) via b0, b1, b2, b3, b4, b5, b6
plot "" every ::::2000 using (Volumen($1, phi_min, phi_max)):2 title "Messwerte", \
	x < 210 ? iso_p(x, a, b) + shift : iso_p(x, a, b) title "Trennkurve", \
	poly_p(x, a0, a1, a2, a3, a4, a5, a6) title sprintf(frmt_top, a0, a1, a2, a3, a4, a5, a6), \
	poly_p(x, b0, b1, b2, b3, b4, b5, b6) title sprintf(frmt_bottom, b0, b1, b2, b3, b4, b5, b6) linestyle 5
print "16V"
print "a0 = ", a0, "; a1 = ", a1, "; a2 = ", a2, "; a3 = ", a3, "; a4 = ", a4, "; a5 = ", a5, "; a6 = ", a6
print "b0 = ", b0, "; b1 = ", b1, "; b2 = ", b2, "; b3 = ", b3, "; b4 = ", b4, "; b5 = ", b5, "; b6 = ", b6
print "I1 = ", poly_int(V_max, a0, a1, a2, a3, a4, a5, a6) - poly_int(V_min, a0, a1, a2, a3, a4, a5, a6)
print "I2 = ", poly_int(V_max, b0, b1, b2, b3, b4, b5, b6) - poly_int(V_min, b0, b1, b2, b3, b4, b5, b6)
print ""

