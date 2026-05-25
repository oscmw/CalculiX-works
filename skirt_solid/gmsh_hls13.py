import gmsh
import sys

gmsh.initialize()
#gmsh.model.add("gmsh_hls6")

# ------------------------------
# Import STEP geometry
# ------------------------------
gmsh.model.occ.importShapes("730-C-501_Onsh8.step")
gmsh.model.occ.fragment([(2, 23)], [(2, 18), (2, 19)])
gmsh.model.occ.fragment([(2, 23)], [(2, 24), (2, 25)])
gmsh.model.occ.synchronize()

# Re-query — old tags 17 and 24 may no longer exist
surfaces = gmsh.model.getEntities(2)
surface_tags = [tag for dim, tag in surfaces]
print("Surfaces after fragment:", surface_tags)

lc = 265

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
# Get FINAL surfaces (after OCC)
# ------------------------------
surfaces = gmsh.model.getEntities(2)
surface_tags = [tag for dim, tag in surfaces]

# ------------------------------
# Recombine (structured mesh)
# ------------------------------

for s in list(range(18, 22)) + list(range(24, 32)):
    gmsh.model.mesh.setTransfiniteSurface(s)
    gmsh.model.mesh.setRecombine(2, s)
#    
    

# ------------------------------
# Physical groups (SAFE)
# ------------------------------
def safe_group(tags, name):
    valid = [t for t in tags if t in surface_tags]
    if valid:
        gmsh.model.addPhysicalGroup(2, valid, name=name)

safe_group([22], "skir_sless")
safe_group([23], "skir_carbo_mid")
safe_group([17], "skir_carbo_und")

safe_group(range(1,9), "ovalop1_surf")
safe_group(range(9,17), "ovalop2_surf")
safe_group(range(24,28), "opening2_surf")
safe_group(range(18,22), "manhole_surf")
#safe_group(range(28,32), "base_plate")

#safe_group([32], "base_plate_inner_YFIX")


points = gmsh.model.getEntities(0)
gmsh.model.mesh.setSize(points, lc)

# ------------------------------
# Mesh options
# ------------------------------
gmsh.option.setNumber("Mesh.Algorithm", 2)
gmsh.option.setNumber("Mesh.RecombineAll", 1)
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
gmsh.model.mesh.removeDuplicateNodes()

gmsh.model.mesh.reverse([(2,22)])

# ------------------------------
# Save
# ------------------------------
gmsh.write("gmsh_hls13.med")

#if "-nopopup" not in sys.argv:
   # gmsh.fltk.run()

gmsh.finalize()
