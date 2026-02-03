SetFactory("OpenCASCADE");

// ------------------------------
// Parameters (mesh-level control)
// ------------------------------
div_circ        = 40;
div_uppe_radwd  =  2;
div_base_radwd  =  4;
div_sless_heigh = 10;
div_carbo_heigh = 40;

// ------------------------------
// Import geometry
// ------------------------------
Merge "Skirt_DefeatConvrt_copy.step";

// ------------------------------
// Physical groups
// ------------------------------
Physical Surface("skir_carbo") = {2};
Physical Surface("base_plate") = {3};
Physical Surface("uppe_plate") = {4};
Physical Surface("skir_sless") = {1};
Physical Curve("skir_sless_uprin") = {3};
Physical Curve("skir_sless_lorin") = {2};
Physical Curve("skir_sless_heigh") = {1};
Physical Curve("skir_carbo_heigh") = {4};
Physical Curve("skir_carbo_lorin") = {5};
Physical Curve("uppe_plate_inrin") = {11};
Physical Curve("uppe_plate_ourin") = {12};
Physical Curve("base_plate_radwd") = {7};
Physical Curve("uppe_plate_radwd") = {10};
Physical Curve("base_plate_inrin") = {8};
Physical Curve("base_plate_ourin") = {9};

// try meshing without and with the below merge
// ------------------------------
// to force shared edges have shared nodes
// ------------------------------
BooleanFragments{ Surface{1}; Delete; }{ Surface{2}; Delete; }
// Note the generated skir_w_upplt has surface #16


// ------------------------------
// Mesh control
// ------------------------------
// Characteristic Length{ PointsOf{ Surface{2}; } } = lc_wall;//+
Transfinite Curve { 1 } = div_sless_heigh Using Progression 1;
Transfinite Curve { 4 } = div_carbo_heigh Using Progression 1;
Transfinite Curve { 2, 3, 5, 8, 9, 11, 12 } = div_circ Using Progression 1;
Transfinite Curve { 10 } = div_uppe_radwd Using Progression 1;
Transfinite Curve { 7 } = div_base_radwd Using Progression 1;
Transfinite Surface {1,2,3,4};