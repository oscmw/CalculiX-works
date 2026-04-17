import meshio
mesh = meshio.read("salome_hls_6.med", file_format="med")
meshio.write("salome_hls_6.inp", mesh, file_format="abaqus")
