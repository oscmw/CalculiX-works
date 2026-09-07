set terminal pngcairo size 900,650 enhanced font 'Arial,12'
set output 'graph_S4_all.png'
set xlabel 'Displacement (mm)'
set ylabel 'Reaction Force (N)'
set title 'Load-Displacement Curve'
set grid
set key top right

plot \
    'S4_0_ss-2.dat'    using 2:(-$3) with linespoints pt 7 ps 1.2 lw 2 lc rgb '#2060c0' title 'Displacement scale 0', \
    'S4_e3_ss-2.dat'  using 2:(-$3) with linespoints pt 5 ps 1.2 lw 2 lc rgb '#c02020' title 'Displacement scale e3', \
    'S4_e4_ss-2.dat'  using 2:(-$3) with linespoints pt 9 ps 1.2 lw 2 lc rgb '#20a040' title 'Displacement scale e4'

