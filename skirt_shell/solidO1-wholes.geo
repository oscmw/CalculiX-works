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

// ------------------------------
// to force shared edges have shared nodes
// ------------------------------
// skir_carbo_mid and skir_carbo_und
// BooleanUnion{ Surface{5:6}; Delete; }{ } // cannot be performed


// ====================================================
// SET IN-PLANE MESH SIZE
// ====================================================

// Set characteristic length for all points in the base surface
// This controls the in-plane mesh density

Characteristic Length { PointsOf{Volume{1:6};} } = lc;
// Characteristic Length { PointsOf{Curve{13:22,64,66,81:87};} } = 0.5*lc;

