set terminal pngcairo size 1200,800
set output 'S8R_all_256.png'
set xlabel 'Displacement (mm)'
set ylabel 'Reaction Force (N)'
set title 'Load-Displacement Curves'
set grid
set key top right
plot \
    'load_disp_S8R_0_256.dat' using 2:(-$6) with linespoints pt 7 ps 1.2 lw 2 title 'Displacement scale 0', \
    'load_disp_S8R_e3_256.dat' using 2:(-$6) with linespoints pt 5 ps 1.2 lw 2 title 'Displacement scale e3', \
    'load_disp_S8R_e4_256.dat' using 2:(-$6) with linespoints pt 9 ps 1.2 lw 2 title 'Displacement scale e4'