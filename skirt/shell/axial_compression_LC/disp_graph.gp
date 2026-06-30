set terminal pngcairo size 1400,800 enhanced font 'Arial,12'
set output 'results_disp.png'
set title "Displacement Statistics per Increment"
set xlabel "Increment"
set ylabel "Displacement, L/L_0"
set grid
set key outside right top
# Column reference:
# 1=INC  2=TIME
# 3=VX_AVG  4=VX_STD  5=VX_MIN  6=VX_MAX
# 7=VY_AVG  8=VY_STD  9=VY_MIN  10=VY_MAX
# 11=VZ_AVG 12=VZ_STD 13=VZ_MIN 14=VZ_MAX
# Min/Max bands
set style fill transparent solid 0.15 noborder
plot \
  'disp.dat' using 1:5:6   with filledcurves lc rgb 'red'   title 'VX min/max', \
  'disp.dat' using 1:($3-$4):($3+$4) with filledcurves lc rgb 'dark-red' title 'VX std dev', \
  'disp.dat' using 1:3     with linespoints lw 2 lc rgb 'red'   title 'VX avg', \
  \
  'disp.dat' using 1:9:10  with filledcurves lc rgb 'green' title 'VY min/max', \
  'disp.dat' using 1:($7-$8):($7+$8) with filledcurves lc rgb 'dark-green' title 'VY std dev', \
  'disp.dat' using 1:7     with linespoints lw 2 lc rgb 'dark-green' title 'VY avg', \
  \
  'disp.dat' using 1:13:14 with filledcurves lc rgb 'blue'  title 'VZ min/max', \
  'disp.dat' using 1:($11-$12):($11+$12) with filledcurves lc rgb 'dark-blue' title 'VZ std dev', \
  'disp.dat' using 1:11    with linespoints lw 2 lc rgb 'blue'  title 'VZ avg'