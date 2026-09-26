set terminal pngcairo size 900,650 enhanced font 'Arial,12'
set output 'graph_all.png'

set xlabel 'Displacement (mm)'
set ylabel 'Reaction Force (N)'
set title 'Load-Displacement Curve for S4, S6, S8R'
set grid
set key top left

plot \
    'S4_e3_128_ss-2.dat' using 2:(-$4) with linespoints pt 7 ps 1.2 lw 2 title 'S4 e3 lc:128', \
    'S4_0_128.dat'       using 2:(-$4) with linespoints pt 7 ps 1.2 lw 2 title 'S4 0 lc:128', \
    'S6_e3_256.dat'      using 2:(-$4) with linespoints pt 7 ps 1.2 lw 2 title 'S6 e3 lc:256', \
    'S8R_0_256.dat'      using 2:(-$4) with linespoints pt 7 ps 1.2 lw 2 title 'S8R 0 lc:256', \
    'S8R_e3_256.dat'     using 2:(-$4) with linespoints pt 7 ps 1.2 lw 2 title 'S8R e3 lc:256'