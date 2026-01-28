// Deep drawing setup - Line-only Tools (Punch, Holder, Die) + Surface Blank
SetFactory("OpenCASCADE");

// ====================== PARAMETRELER ======================
T      = 1;      // sac kalınlığı
Wp     = 15;     // punch genişliği (r yönü)
Hp     = 25;     // punch yüksekliği
Hh     = 8;      // blank holder yüksekliği
Hd     = 35;     // die derinliği
wBD    = 20;     // hem blank holder hem die genişliği (EŞİT)

// Fillet yarıçapları
RfP    = 3;      // punch alt iç radius
RfD    = 3;      // die üst iç radius

// Gap oranları
cRatio = 1.1;    
vRatio = 0.001;
gapR = cRatio * T;   
gapV = vRatio * T;

Rblank = Wp + gapR + wBD;
lc_blank = T / 1.0;
lc_tool  = 5.0;

// =====================================================
// 1) PUNCH (Lines Only)
// =====================================================
yPunchBot = T + gapV;
yPunchTop = yPunchBot + Hp;

Point(1) = {0,          yPunchBot,       0, lc_tool};
Point(2) = {Wp - RfP,   yPunchBot,       0, lc_tool/2};
Point(3) = {Wp,         yPunchBot + RfP, 0, lc_tool/2};
Point(4) = {Wp,         yPunchTop,       0, lc_tool};
Point(5) = {0,          yPunchTop,       0, lc_tool};
Point(101) = {Wp - RfP, yPunchBot + RfP, 0, lc_tool};

Line(1)   = {1, 2};             
Circle(2) = {2, 101, 3};        
Line(3)   = {3, 4};             
Line(4)   = {4, 5};
Line(5)   = {5, 1};             

// Yüzey
Line Loop(10)     = {1, 2, 3, 4, 5};
Plane Surface(11) = {10};

// Physical groups for NodeSets
Physical Curve("PunchBottom") = {1, 2};
Physical Curve("PunchSide")   = {3};
Physical Curve("PunchTop")    = {4};
Physical Curve("PunchCenter") = {5};
Physical Surface("Punch")    = {11};

// =====================================================
// 2) BLANK (Sac - Surface Kept for Deformation)
// =====================================================
Point(10) = {0,      0, 0, lc_blank};
Point(11) = {Rblank, 0, 0, lc_blank};
Point(12) = {Rblank, T, 0, lc_blank};
Point(13) = {0,      T, 0, lc_blank};

Line(10) = {10, 11};   
Line(11) = {11, 12};
Line(12) = {12, 13};   
Line(13) = {13, 10};

Line Loop(20)     = {10, 11, 12, 13};
Plane Surface(21) = {20};

Transfinite Curve {11, 13} = 5; 
Transfinite Surface {21};
Recombine Surface {21};

Physical Surface("Blank")    = {21};
Physical Curve("BlankBottom") = {10};
Physical Curve("BlankTop")    = {12};
Physical Curve("BlankOuter")  = {11};
Physical Curve("BlankInner")  = {13};

// =====================================================
// 3) HOLDER (Lines Only)
// =====================================================
rBH_in  = Wp + gapR;
rBH_out = rBH_in + wBD;

Point(20) = {rBH_in,  T,     0, lc_tool/2};
Point(21) = {rBH_out, T,     0, lc_tool};
Point(22) = {rBH_out, T+Hh,  0, lc_tool};
Point(23) = {rBH_in,  T+Hh,  0, lc_tool};

Line(20) = {20, 21};
Line(21) = {21, 22};
Line(22) = {22, 23};
Line(23) = {23, 20};

Line Loop(30)     = {20, 21, 22, 23};
Plane Surface(31) = {30};

Physical Surface("BlankHolder")   = {31};
Physical Curve("BH_Bottom") = {20};
Physical Curve("BH_Outer")  = {21};
Physical Curve("BH_Top")    = {22};
Physical Curve("BH_Inner")  = {23};

// =====================================================
// 4) DIE (Lines Only)
// =====================================================
rDie_in  = rBH_in;       
rDie_out = rBH_out;

Point(30) = {rDie_in + RfD,  0,    0, lc_tool/2};
Point(31) = {rDie_out,       0,    0, lc_tool};
Point(32) = {rDie_out,      -Hd,   0, lc_tool};
Point(33) = {rDie_in,       -Hd,   0, lc_tool};
Point(34) = {rDie_in,       -RfD,  0, lc_tool/2};
Point(130) = {rDie_in + RfD, -RfD, 0, lc_tool};

Line(30)   = {30, 31};          
Line(31)   = {31, 32};
Line(32)   = {32, 33};          
Line(33)   = {33, 34};
Circle(34) = {34, 130, 30};     

// Yüzey (die)
Line Loop(40)     = {30, 31, 32, 33, 34};
Plane Surface(41) = {40};

Physical Surface("Die")      = {41};
Physical Curve("DieTop")    = {30, 34};  
Physical Curve("DieOuter")  = {31};
Physical Curve("DieBottom") = {32};      
Physical Curve("DieInner")  = {33};

// ====================== MESH SETTINGS ======================
Mesh.ElementOrder = 2;
Mesh.SecondOrderIncomplete = 1;
//Mesh.SecondOrderLinear = 1;
Mesh.SaveGroupsOfNodes = 1;
Mesh.SaveGroupsOfElements = 1;
Mesh.Format = 39;
Mesh.RecombineAll = 1;
Mesh.RecombinationAlgorithm = 1;
//Mesh 1;
Mesh 2;
