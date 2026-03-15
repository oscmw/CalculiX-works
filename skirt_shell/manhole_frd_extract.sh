#!/usr/bin/env bash
# Kullanım:
#   bash manhole_frd_extract.sh whole_24.frd
# veya
#   bash manhole_frd_extract.sh whole_36.frd

set -euo pipefail

FRD="${1:-}"
if [ -z "$FRD" ]; then
  echo "Kullanim: bash manhole_frd_extract.sh whole_xx.frd"
  exit 1
fi

if [ ! -f "$FRD" ]; then
  echo "Dosya bulunamadi: $FRD"
  exit 1
fi

# Manhole geometrisi
Y0=-285.0
Z0=0.0
R0=330.0

# Tolerans:
# mesh sık ise 1.0 iyidir
# az node seçerse 2.0 veya 3.0 deneyebilirsin
TOL=1.5

BASE="${FRD%.frd}"

awk -v y0="$Y0" -v z0="$Z0" -v r0="$R0" -v tol="$TOL" '
function abs(x){ return x<0 ? -x : x }
function acos_clamped(x){
  if (x > 1) x = 1
  if (x < -1) x = -1
  return atan2(sqrt(1 - x*x), x)
}
function sort3(a,b,c,   t){
  p1=a; p2=b; p3=c
  if (p1 < p2) { t=p1; p1=p2; p2=t }
  if (p2 < p3) { t=p2; p2=p3; p3=t }
  if (p1 < p2) { t=p1; p1=p2; p2=t }
}
function upd(name, val, nid, ang){
  if (!(name in minv) || val < minv[name]) {
    minv[name]=val; minn[name]=nid; mina[name]=ang
  }
  if (!(name in maxv) || val > maxv[name]) {
    maxv[name]=val; maxn[name]=nid; maxa[name]=ang
  }
}
BEGIN{
  in_nodes=0
  in_stress=0
  pi = atan2(0,-1)

  print "angle_deg,node,SXX"        > "plot_SXX.csv"
  print "angle_deg,node,SYY"        > "plot_SYY.csv"
  print "angle_deg,node,SZZ"        > "plot_SZZ.csv"
  print "angle_deg,node,SXY"        > "plot_SXY.csv"
  print "angle_deg,node,SYZ"        > "plot_SYZ.csv"
  print "angle_deg,node,SZX"        > "plot_SZX.csv"
  print "angle_deg,node,VONMISES"   > "plot_VM.csv"
  print "angle_deg,node,PMAX"       > "plot_PMAX.csv"
  print "angle_deg,node,PMIN"       > "plot_PMIN.csv"
  print "angle_deg,node,MAXSHEAR"   > "plot_MAXSHEAR.csv"
}

{
  line=$0

  # Node section başlangıcı:
  # Birçok FRD dosyasında node blok başlığında "2C" geçer.
  if (index(line, "2C") > 0) {
    in_nodes=1
    next
  }

  # Stress result section başlangıcı
  if (substr(line,6,6)=="STRESS") {
    in_stress=1
    next
  }

  # Section sonu
  if (substr(line,2,2)=="-3") {
    if (in_nodes)  in_nodes=0
    if (in_stress) in_stress=0
    next
  }

  # Node satırları
  if (in_nodes && substr(line,2,2)=="-1") {
    nid = int(substr(line,5,9))
    x = substr(line,14,12)+0
    y = substr(line,26,12)+0
    z = substr(line,38,12)+0

    rr = sqrt((y-y0)^2 + (z-z0)^2)
    if (abs(rr-r0) <= tol) {
      keep[nid]=1
      ny[nid]=y
      nz[nid]=z
      ang = atan2(z-z0, y-y0) * 180/pi
      if (ang < 0) ang += 360
      nang[nid]=ang
    }
    next
  }

  # Stress satırları
  if (in_stress && substr(line,2,2)=="-1") {
    nid = int(substr(line,5,9))
    if (!(nid in keep)) next

    sxx = substr(line,14,12)+0
    syy = substr(line,26,12)+0
    szz = substr(line,38,12)+0
    sxy = substr(line,50,12)+0
    syz = substr(line,62,12)+0
    szx = substr(line,74,12)+0

    # von Mises
    vm = sqrt(0.5*((sxx-syy)^2 + (syy-szz)^2 + (szz-sxx)^2) + 3*(sxy^2 + syz^2 + szx^2))

    # principal stresses
    I1 = sxx + syy + szz
    I2 = sxx*syy + syy*szz + szz*sxx - sxy*sxy - syz*syz - szx*szx
    I3 = sxx*syy*szz + 2*sxy*syz*szx - sxx*syz*syz - syy*szx*szx - szz*sxy*sxy

    p = I1*I1 - 3*I2

    if (p < 1e-20) {
      p1 = I1/3
      p2 = I1/3
      p3 = I1/3
    } else {
      q = 2*I1*I1*I1 - 9*I1*I2 + 27*I3
      phi = acos_clamped(q / (2*sqrt(p*p*p))) / 3.0
      p1 = (I1 + 2*sqrt(p)*cos(phi)) / 3.0
      p2 = (I1 + 2*sqrt(p)*cos(phi - 2*pi/3)) / 3.0
      p3 = (I1 + 2*sqrt(p)*cos(phi + 2*pi/3)) / 3.0
    }

    sort3(p1,p2,p3)
    pmax = p1
    pmid = p2
    pmin = p3
    ms   = (pmax - pmin)/2.0

    a = nang[nid]

    printf "%.6f,%d,%.12e\n", a, nid, sxx  >> "plot_SXX.csv"
    printf "%.6f,%d,%.12e\n", a, nid, syy  >> "plot_SYY.csv"
    printf "%.6f,%d,%.12e\n", a, nid, szz  >> "plot_SZZ.csv"
    printf "%.6f,%d,%.12e\n", a, nid, sxy  >> "plot_SXY.csv"
    printf "%.6f,%d,%.12e\n", a, nid, syz  >> "plot_SYZ.csv"
    printf "%.6f,%d,%.12e\n", a, nid, szx  >> "plot_SZX.csv"
    printf "%.6f,%d,%.12e\n", a, nid, vm   >> "plot_VM.csv"
    printf "%.6f,%d,%.12e\n", a, nid, pmax >> "plot_PMAX.csv"
    printf "%.6f,%d,%.12e\n", a, nid, pmin >> "plot_PMIN.csv"
    printf "%.6f,%d,%.12e\n", a, nid, ms   >> "plot_MAXSHEAR.csv"

    upd("SXX", sxx, nid, a)
    upd("SYY", syy, nid, a)
    upd("SZZ", szz, nid, a)
    upd("SXY", sxy, nid, a)
    upd("SYZ", syz, nid, a)
    upd("SZX", szx, nid, a)
    upd("VM", vm, nid, a)
    upd("PMAX", pmax, nid, a)
    upd("PMIN", pmin, nid, a)
    upd("MAXSHEAR", ms, nid, a)
  }
}

END{
  print "component,min_value,min_node,min_angle_deg,max_value,max_node,max_angle_deg" > "summary.csv"

  nlist[1]="SXX"
  nlist[2]="SYY"
  nlist[3]="SZZ"
  nlist[4]="SXY"
  nlist[5]="SYZ"
  nlist[6]="SZX"
  nlist[7]="VM"
  nlist[8]="PMAX"
  nlist[9]="PMIN"
  nlist[10]="MAXSHEAR"

  for (i=1; i<=10; i++) {
    k=nlist[i]
    if (k in minv) {
      printf "%s,%.12e,%d,%.6f,%.12e,%d,%.6f\n",
        k, minv[k], minn[k], mina[k], maxv[k], maxn[k], maxa[k] >> "summary.csv"
    }
  }
}
' "$FRD"

mkdir -p "${BASE}_manhole"
mv plot_*.csv summary.csv "${BASE}_manhole"/

for f in "${BASE}_manhole"/plot_*.csv; do
  head -n 1 "$f" > "${f}.tmp"
  tail -n +2 "$f" | sort -t, -k1,1n >> "${f}.tmp"
  mv "${f}.tmp" "$f"
done

echo "Bitti."
echo "Klasor: ${BASE}_manhole"
echo "Ozet:   ${BASE}_manhole/summary.csv"
