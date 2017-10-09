set terminal pdf size 5in, 4in
set output 'gnuplot_histogram.pdf'
set boxwidth 0.9 absolute
set style fill solid 1.00 border lt -1
set key inside right top vertical Right noreverse noenhanced autotitle nobox
set style histogram clustered gap 1 title textcolor lt -1
set datafile missing '-'
set style data histograms
set xtics border in scale 0,0 nomirror rotate by -45  autojustify
set xtics norangelimit
set xtics ()
set title "US immigration from Northern Europe\nPlot selected data columns as histogram of clustered boxes"
set yrange [0:300000] noreverse nowriteback
x = 0.0
i = 22
plot 'immigration.dat' using 6:xtic(1) ti col, '' u 12 ti col, '' u 13 ti col, '' u 14 ti col

# ===========================
reset

set terminal pdf size 5in, 4in
set output 'gnuplot_silver.pdf'
set samples 300
set xlabel "Time (sec)"
set ylabel "Rate"
set title "Ag 108 decay data"
set logscale y
set grid x y mx my
set logscale y
plot "silver.dat" t "rate" w errorb, \
               "" smooth sbezier t "bezier"

# ===========================
reset

set terminal pdf size 5in, 4in
set output 'gnuplot_pm3d.pdf'
#set border 4095 front lt black linewidth 1.000 dashtype solid
set view 50, 220, 1, 1
set samples 30, 30
set isosamples 30, 30
set hidden3d back offset 1 trianglepattern 3 undefined 1 altdiagonal bentover
set xrange [-10:10] noreverse nowriteback
set yrange [-10:10] noreverse nowriteback
set pm3d implicit at s
x = 0.0
#splot log(x*x*y*y)
splot sin(sqrt(x**2+y**2))/sqrt(x**2+y**2) notitle

