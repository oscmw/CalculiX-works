set terminal pngcairo size 1200,600 enhanced font 'Arial,12'
set output 'results_force.png'

set title "Reaction Force per Increment"
set xlabel "Increment"
set ylabel "RF3 (N)"
set grid
set key outside right top

plot 'force.dat' every ::1 using 1:2 with linespoints lw 2 lc rgb 'red'   title 'RF1', \
     'force.dat' every ::1 using 1:3 with linespoints lw 2 lc rgb 'green' title 'RF2', \
     'force.dat' every ::1 using 1:4 with linespoints lw 2 lc rgb 'blue'  title 'RF3'