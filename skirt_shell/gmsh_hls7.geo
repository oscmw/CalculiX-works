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
Merge "730-C-501_Onsh8.step";


// ------------------------------
// to force shared edges have shared nodes
// ------------------------------

// BooleanFragments{ Surface{23}; Delete; }{ Surface{27:30}; Delete; }
// BooleanFragments{ Surface{24}; Delete; }{ Surface{19:22}; Delete; }

// base_plate, upper_plate, skir_carbo_und as targets and 40 gusset plates as tools


Recombine Surface{1:31};
 
// ------------------------------
// Physical groups
// ------------------------------
Physical Surface("skir_sless") = {22};
Physical Surface("skir_carbo_mid") = {23};
Physical Surface("skir_carbo_und") = {17};

//Physical Surface("ovalop1_surf") = {1:8};
//Physical Surface("ovalop2_surf") = {9:16};
//Physical Surface("opening2_surf") = {24,27};
//Physical Surface("manhole_surf") = {18:21};

Physical Curve("base_plate_center_YFIX") = {84,89};
Physical Curve("skir_sless_top_LOAD") = {54,57};

// ------------------------------
// Mesh control
// ------------------------------
Characteristic Length{ PointsOf{ Surface{17,22,23}; } } = lc; //+


// make sure to generate second order elements:
 Mesh.Algorithm = 2; // Automatic
 Mesh.ElementOrder = 2; // Create second order elements.
 Mesh.SecondOrderIncomplete = 1;

// the mesh is generated and exported
Mesh.Format = 39; // Save mesh as INP format.
Mesh.SaveGroupsOfNodes = 1;
Mesh.SaveGroupsOfElements = 2;
Mesh.SaveAll = 0; //only pyhsical groups are saved
Mesh.Optimize = 2;
Mesh 2;
// OptimizeMesh "Gmsh";

Geometry.Tolerance = 5.e-4;
Coherence Mesh;
 Save "gmsh_hls7.inp";