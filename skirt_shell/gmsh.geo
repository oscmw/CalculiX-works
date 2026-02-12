SetFactory("OpenCASCADE");

// ------------------------------
// Parameters (mesh-level control)
// ------------------------------
div_circ        = 40;
div_uppe_rad    =  2;
div_base_rad    =  2;
div_sless_heigh = 10;
div_carbo_heigh = 40;

// ------------------------------
// Import geometry
// ------------------------------
Merge "Skirt_DefeatConvrt.step";

// ------------------------------
// to force shared edges have shared nodes
// ------------------------------
BooleanFragments{ Surface{3}; Delete; }{ Surface{4}; Delete; }
BooleanDifference{ Surface{4}; Delete; }{ Surface{1}; Delete; }
BooleanFragments{ Surface{4}; Delete; }{ Surface{2}; Delete; }

// ------------------------------
// Physical groups
// ------------------------------
Physical Surface("skir_carbo_body") = {5};
Physical Surface("skir_carbo_undc") = {4};
Physical Surface("base_plate_cutin") = {6};
Physical Surface("base_plate_cutou") = {7};
Physical Surface("uppe_plate") = {1};
Physical Surface("skir_sless") = {3};

Physical Curve("skir_sless_uprin") = {9};
Physical Curve("skir_sless_lorin") = {7};
Physical Curve("skir_sless_heigh") = {8};
Physical Curve("skir_carbo_body_heigh") = {13};
Physical Curve("skir_carbo_undc_heigh") = {10};
Physical Curve("skir_carbo_lorin") = {12};
Physical Curve("skir_carbo_ctrin") = {11};
Physical Curve("uppe_plate_inrin") = {2};
Physical Curve("uppe_plate_ourin") = {3};
Physical Curve("base_plate_radin") = {15};
Physical Curve("base_plate_radou") = {16};
Physical Curve("uppe_plate_rad") = {1};
Physical Curve("base_plate_inrin") = {14};
Physical Curve("base_plate_ourin") = {17};

// ------------------------------
// Mesh control
// ------------------------------
// Characteristic Length{ PointsOf{ Surface{2}; } } = lc_wall;//+
Transfinite Curve { 8 } = div_sless_heigh Using Progression 1;
Transfinite Curve { 13 } = div_carbo_heigh Using Progression 1;
Transfinite Curve { 9, 7, 12, 11, 2, 3, 14, 17 } = div_circ Using Progression 1;
Transfinite Curve { 1 } = div_uppe_rad Using Progression 1;
Transfinite Curve { 15, 16 } = div_base_rad Using Progression 1;

Recombine Surface{1,3,4,5,6,7};

// make sure to generate second order elements:
// Mesh.Algorithm = 2; // Automatic
// Mesh.ElementOrder = 2; // Create second order elements.
// Mesh.SecondOrderIncomplete = 1;

// the mesh is generated and exported
Mesh.Format = 39; // Save mesh as INP format.
Mesh.SaveGroupsOfNodes = 1;
Mesh.SaveGroupsOfElements = 1;
Mesh.Optimize = 1;
Mesh 2;
// OptimizeMesh "Gmsh";
// Coherence Mesh;
Save "gmsh.inp";