set terminal pngcairo size 900,650 enhanced font 'Arial,12'
set output 'graph_S4_e3_128.png'
set xlabel 'Displacement (mm)'
set ylabel 'Reaction Force (N)'
set title 'Load-Displacement Curve'
set grid
set key top left

plot \
    'S4_e3_128_ss-2.dat'    using 2:(-$4) with linespoints pt 7 ps 1.2 lw 2 lc rgb '#2060c0' title 'S4 disp:1000 lc:128'

S4_0_128.dat

S8R_0_256.dat

S8R_e3_256.dat

S6_e3_256.dat