import gmsh
import sys

gmsh.initialize()
#gmsh.model.add("gmsh_hls6")

# ------------------------------
# Import STEP geometry
# ------------------------------
gmsh.model.occ.importShapes("730-C-501_Onsh6.step")
gmsh.model.occ.synchronize()

lc = 80

# ------------------------------
# DEBUG: get actual OCC surfaces
# ------------------------------
occ_surfaces = gmsh.model.occ.getEntities(2)
occ_tags = [tag for dim, tag in occ_surfaces]

print("OCC surface tags:", occ_tags)

# ------------------------------
# SAFE helper
# ------------------------------
def keep(tags):
    return [(2, t) for t in tags if t in occ_tags]

# ------------------------------
# BooleanFragments (SAFE)
# ------------------------------

# original: Surface{23} with {1:16,27:30}
#gmsh.model.occ.fragment(
#    keep([24]),
#    keep([17])
#)
#gmsh.model.occ.synchronize()



# original: Surface{64,65,66,4} with {1,25:63}
#targets = keep(list(range(1,16)))
#tools   = keep([17]) 

#if targets and tools:
#    gmsh.model.occ.fragment(targets, tools)
#    gmsh.model.occ.synchronize()
#else:
#    print("[warning] skipped main fragment (tags not found)")

# ------------------------------
# Get FINAL surfaces (after OCC)
# ------------------------------
surfaces = gmsh.model.getEntities(2)
surface_tags = [tag for dim, tag in surfaces]

# ------------------------------
# Recombine (structured mesh)
# ------------------------------
for s in surface_tags:
    gmsh.model.mesh.setRecombine(2, s)

# ------------------------------
# Physical groups (SAFE)
# ------------------------------
def safe_group(tags, name):
    valid = [t for t in tags if t in surface_tags]
    if valid:
        gmsh.model.addPhysicalGroup(2, valid, name=name)

safe_group([21], "skir_sless")
safe_group([20], "skir_carbo_mid")
safe_group([17], "skir_carbo_und")

safe_group(range(1, 9), "ovalop1_surf")
safe_group(range(9, 17), "ovalop2_surf")
safe_group([21, 22], "opening2_surf")
safe_group([18, 19], "manhole_surf")
safe_group([23, 24], "base_plate")

#safe_group([32], "base_plate_inner_YFIX")

points = gmsh.model.getEntities(0)
gmsh.model.mesh.setSize(points, lc)

# ------------------------------
# Mesh options
# ------------------------------
gmsh.option.setNumber("Mesh.Algorithm", 2)
gmsh.option.setNumber("Mesh.ElementOrder", 2)
gmsh.option.setNumber("Mesh.SecondOrderIncomplete", 1)

gmsh.option.setNumber("Mesh.Format", 33)
gmsh.option.setNumber("Mesh.SaveGroupsOfNodes", 1)
gmsh.option.setNumber("Mesh.SaveGroupsOfElements", 1)
gmsh.option.setNumber("Mesh.Optimize", 1)

#gmsh.option.setNumber("Geometry.Tolerance", 5e-4)
# ------------------------------
# ------------------------------
# Mesh sizing
# ------------------------------

# ------------------------------


# ------------------------------
# Generate mesh
# ------------------------------
gmsh.model.mesh.generate(2)
#gmsh.model.mesh.removeDuplicateNodes()

# ------------------------------
# Save
# ------------------------------
gmsh.write("gmsh_hls_1.med")

#if "-nopopup" not in sys.argv:
   # gmsh.fltk.run()

gmsh.finalize()
