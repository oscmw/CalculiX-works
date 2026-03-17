SetFactory("OpenCASCADE");

// ------------------------------
// Parameters (mesh-level control)
// ------------------------------
div_circ        = 40;
div_uppe_rad    =  2;
div_base_rad    =  2;
div_sless_heigh = 10;
div_carbo_heigh = 40;
lc              = 265;

// ------------------------------
// Import geometry
// ------------------------------
Merge "730-C-501_Onsh4.step";


// ------------------------------
// to force shared edges have shared nodes
// ------------------------------
// skir_sless and skir_carbo_mid
 BooleanFragments{ Surface{2}; Delete; }{ Surface{3}; Delete; }

// skir_carbo_mid and skir_carbo_und
 BooleanFragments{ Surface{3}; Delete; }{ Surface{4}; Delete; }

// skir_carbo_und and upper_plate
 BooleanFragments{ Surface{4}; Delete; }{ Surface{64}; Delete; }

// skir_carbo_und and base_plate
 BooleanFragments{ Surface{4}; Delete; }{ Surface{65}; Delete; }

// skir_carbo_mid (target) and two oval openings (tools)
 BooleanFragments{ Surface{3}; Delete; }{ Surface{5:8}; Delete; }
 BooleanFragments{ Surface{3}; Delete; }{ Surface{9:12}; Delete; }
 BooleanFragments{ Surface{3}; Delete; }{ Surface{22}; Delete; } //
 BooleanFragments{ Surface{3}; Delete; }{ Surface{24}; Delete; } //

// base_plate, upper_plate, skir_carbo_und as targets and 40 gusset plates as tools
 BooleanFragments{ Surface{64,65,66,4}; Delete; }{ Surface{1,25:63}; Delete; }

 Recombine Surface{1:186};
//Recombine Surface{1,17:153};
 
// ------------------------------
// Physical groups
// ------------------------------
Physical Surface("skir_sless") = {2};
Physical Surface("skir_carbo_mid") = {3};
Physical Surface("skir_carbo_und") = {147:186};

Physical Surface("ovalop1_surf") = {5:12};
Physical Surface("ovalop2_surf") = {13:20};
Physical Surface("opening2_surf") = {21,22};
Physical Surface("manhole_surf") = {23,24};
Physical Surface("gussets_surf") = {1,25:63};

Physical Surface("base_plate_inner_YFIX") = {66};
Physical Surface("uppe_plate_gusst") = {67:106};
Physical Surface("base_plate_gusst_YFIX") = {107:146};

Physical Curve("skir_sless_uprin_CLOAD") = {242};
Physical Curve("skir_carbo_ctrin_XZFIX") = {490};

Physical Curve("skir_opening2_CONT") = {224};
Physical Curve("skir_manhole_CONT") = {233};

// ------------------------------
// Mesh control
// ------------------------------
Characteristic Length{ PointsOf{ Surface{2,3,5:24}; } } = lc; //+
Characteristic Length{ PointsOf{ Surface{1,25:63,66,67:186}; } } = lc; 

// make sure to generate second order elements:
 Mesh.Algorithm = 2; // Automatic
 Mesh.ElementOrder = 2; // Create second order elements.
 Mesh.SecondOrderIncomplete = 1;

// the mesh is generated and exported
Mesh.Format = 39; // Save mesh as INP format.
Mesh.SaveGroupsOfNodes = 1;
Mesh.SaveGroupsOfElements = 1;
Mesh.Optimize = 1;
Mesh 2;
// OptimizeMesh "Gmsh";

Geometry.Tolerance = 5.e-4;
Coherence Mesh;
// Save "gmsh_hls.inp";

