SetFactory("OpenCASCADE");

// ------------------------------
// Parameters (mesh-level control and geometry)
// ------------------------------
plate_thk	= 25;
lc              = 265;  // element characteristic length
n_layers	= 2;    // number of layers to be extruded

// ------------------------------
// Import geometry
// ------------------------------
Merge "Skirt_DefCon_shell.step";

BooleanFragments{ Surface{1}; Delete; }{ Surface{3}; Delete; };
BooleanFragments{ Surface{2}; Delete; }{ Surface{3}; Delete; };

// ------------------------------
// Physical groups
// ------------------------------
Physical Surface("skir_sless") = {2};
Physical Surface("skir_carbo_mid") = {3};
Physical Surface("skir_carbo_und") = {1};

Physical Curve("skir_sless_uprin_LOAD") = {27};
Physical Curve("skir_carbo_und_FIX") = {23};

Physical Curve("skir_opening2_CONT") = {29};
Physical Curve("skir_manhole_CONT") = {38};

// ====================================================
// SET IN-PLANE MESH SIZE
// ====================================================

// Set characteristic length for all points in the base surface
// This controls the in-plane mesh density

Characteristic Length { PointsOf{Surface{1,2,3};} } = lc;
// Characteristic Length { PointsOf{Curve{29:38};} } = 0.5*lc;

Recombine Surface{1,2,3}

// ------------------------------
// Mesh control
// ------------------------------

 Mesh.Algorithm = 2; // Automatic
 Mesh.ElementOrder = 1; // Create second order elements.
 Mesh.Optimize = 1;
 Mesh 2;
 Geometry.Tolerance = 5.e-4;
 Coherence Mesh;
// Mesh.SecondOrderIncomplete = 1;

// the mesh is generated and exported
Mesh.Format = 39; // Save mesh as INP format.
Mesh.SaveGroupsOfNodes = 1;
Mesh.SaveGroupsOfElements = 1;
//+
Extrude {0, 0, 1} {
  Curve{15}; 
}
//+
Extrude {0, 0, 1} {
  Curve{14}; 
}
//+
Extrude {0, 0, 1} {
  Curve{31}; 
}
//+
Extrude {0, 0, 1} {
  Curve{34}; 
}
//+
Extrude {0, 0, 1} {
  Curve{28}; 
}
//+
Extrude {0, 0, 1} {
  Curve{37}; 
}
//+
Extrude {0, 0, 1} {
  Curve{39}; 
}
//+
Extrude {0, 0, 1} {
  Curve{16}; 
}
