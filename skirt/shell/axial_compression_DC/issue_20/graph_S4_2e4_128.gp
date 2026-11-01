set terminal pngcairo size 900,650 enhanced font 'Arial,12'
set output 'graph_S4_2e4_128.png'
set xlabel 'Displacement (mm)'
set ylabel 'Reaction Force (N)'
set title 'Load-Displacement Curve'
set grid
set key top left

plot \
    'S4_2e4_128.dat'    using 2:(-$4) with linespoints pt 7 ps 1.2 lw 2 lc rgb '#2060c0' title 'S4 disp:2e4 lc:128'
    