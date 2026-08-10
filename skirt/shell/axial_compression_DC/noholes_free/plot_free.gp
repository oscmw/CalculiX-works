# set terminal pngcairo size 1000,700 enhanced font 'Arial,12'
set terminal qt
# set output 'plot_free.png'
set title 'Time vs RF3 Comparison by Element Type'
set xlabel 'time'
set ylabel 'Force'
set grid
set xrange [0:1]
set key top right
plot 'S3_free.dat' using 2:(-$3) with linespoints pt 7 ps 0.6 title 'S3', \
     'S4R_free.dat' using 2:(-$3) with linespoints pt 7 ps 0.6 title 'S4R', \
     'S6_free.dat' using 2:(-$3) with linespoints pt 7 ps 0.6 title 'S6', \
     'S8_free.dat' using 2:(-$3) with linespoints pt 7 ps 0.6 title 'S8', \
     'S8R_free.dat' using 2:(-$3) with linespoints pt 7 ps 0.6 title 'S8R'
