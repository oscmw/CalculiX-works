SetFactory("OpenCASCADE");

// ------------------------------
// Parameters (mesh-level control)
// ------------------------------
div_circ        = 40;
div_uppe_rad    =  2;
div_base_rad    =  2;
div_sless_heigh = 10;
div_carbo_heigh = 40;
lc              = 150;

// ------------------------------
// Import geometry
// ------------------------------
Merge "730-C-501_Onsh3.step";


// ------------------------------
// to force shared edges have shared nodes
// ------------------------------
// skir_sless and skir_carbo_mid
 BooleanFragments{ Surface{2}; Delete; }{ Surface{3}; Delete; }

// skir_carbo_und and upper_plate
 BooleanFragments{ Surface{4}; Delete; }{ Surface{15}; Delete; }

// skir_carbo_mid and skir_carbo_und
 BooleanFragments{ Surface{3}; Delete; }{ Surface{4}; Delete; }

// skir_carbo_mid and skir_carbo_und
 BooleanFragments{ Surface{3}; Delete; }{ Surface{4}; Delete; }

// skir_carbo_und and base_plate
 BooleanFragments{ Surface{4}; Delete; }{ Surface{16}; Delete; }

// skir_carbo_mid (target) and two oval openings (tools)
ovalop1_surf[] = BooleanFragments{ Surface{3}; Delete; }{ Surface{5:8}; Delete; }
ovalop2_surf[] = BooleanFragments{ Surface{3}; Delete; }{ Surface{9:12}; Delete; }
// BooleanFragments{ Surface{3}; Delete; }{ Surface{13}; Delete; } // removes opening
Physical Surface("ovalop1_surf") = {ovalop1_surf[]};
Physical Surface("ovalop2_surf") = {ovalop2_surf[]};

// skir_carbo_mid and skir_carbo_und
 BooleanFragments{ Surface{3}; Delete; }{ Surface{4}; Delete; }
 
// base_plate, upper_plate, skir_carbo_und as targets and 40 gusset plates as tools
 BooleanFragments{ Surface{15,56}; Delete; }{ Surface{1,17:55}; Delete; }

 Recombine Surface{1,2,3,4,13,14,17:153};
 //Recombine Surface{1,17:153};
 
// ------------------------------
// Physical groups
// ------------------------------
Physical Surface("base_plate_cutin") = {55};
Physical Surface("base_plate_cutou") = {56};

Physical Curve("skir_sless_uprin") = {220};
Physical Curve("skir_carbo_ctrin") = {235};

// ------------------------------
// Mesh control
// ------------------------------
    
Characteristic Length{ PointsOf{ Surface{2,3,4,5,6,7,8,9,10,11,12,13,14,57:73}; } } = lc; //+

// Transfinite Curve { 213,214, 220, 235,236,237  } = div_circ Using Progression 1;
// Transfinite Curve {217,218} = div_circ Using Progression 1;
// Transfinite Curve {222} = 30;
// Transfinite Curve {223} = 10;
// Transfinite Curve { 219 } = div_sless_heigh Using Progression 1;
// Transfinite Curve { 221 } = div_carbo_heigh Using Progression 1;

// Transfinite Curve { 1 } = div_uppe_rad Using Progression 1;
// Transfinite Curve { 15, 16 } = div_base_rad Using Progression 1;


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
// Save "gmsh.inp";

