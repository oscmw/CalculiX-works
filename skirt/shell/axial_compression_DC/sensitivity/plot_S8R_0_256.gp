set terminal pngcairo size 900,650 enhanced font 'Arial,12'
set output 'graph_S8R_0_256.png'
set xlabel 'Displacement (mm)'
set ylabel 'Reaction Force (N)'
set title 'Load-Displacement Curve'
set grid
set key top right
plot 'load_disp_S8R_0_256.dat' using 2:(-$6) with linespoints pt 7 ps 1.2 lw 2 lc rgb '#2060c0' title 'Rf3 vs Uz'