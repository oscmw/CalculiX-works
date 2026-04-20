import meshio
mesh = meshio.read("salome_hls13.med", file_format="med")
meshio.write("salome_hls13.inp", mesh, file_format="abaqus")
