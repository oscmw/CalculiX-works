SetFactory("OpenCASCADE");

// ------------------------------
// Parameters (mesh-level control)
// ------------------------------
div_circ        = 40;
div_uppe_rad    =  2;
div_base_rad    =  2;
div_sless_heigh = 10;
div_carbo_heigh = 40;
lc              = 256;
// ------------------------------
// Import geometry
// ------------------------------
Merge "skirt_noholes.step";

//BooleanFragments{ Surface{2}; Delete; }

//Recombine Surface{1:3};
 
// ------------------------------
// Physical groups
// ------------------------------
Physical Surface("skir_sless") = {3};
Physical Surface("skir_carbo_mid") = {1};
Physical Surface("skir_carbo_und") = {2};

Physical Curve("base_plate_center_YFIX") = {4};
Physical Curve("skir_sless_top_LOAD") = {9};

// -----------------------------
// Mesh Control
// -----------------------------

Characteristic Length{ PointsOf{ Surface{1,2,3}; } } = lc; //+

// make sure to generate second order elements:
Mesh.Algorithm = 2; // Automatic 
Mesh.ElementOrder = 2; // Create second order elements.
Mesh.SecondOrderIncomplete = 0;

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

Save "noholes_S6_256.inp";