SetFactory("OpenCASCADE");

// ------------------------------
// Parameters (mesh-level control)
// ------------------------------
lc_wall   = 20;
lc_bottom = 10;
lc_top    = 10;

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

// ------------------------------
// Mesh control
// ------------------------------
Characteristic Length{ PointsOf{ Surface{2}; } } = lc_wall;