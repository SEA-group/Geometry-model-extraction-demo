# Geometry format coding research - part 2

## Purpose
Try to decode the new *.geometry* implemented in 0.11.4? (approximatively) 

## Content
`SectionExtractor_Mk1.m` reads the *.geometry* file and save the largeVertexBlocs and the largeIndexBlocs in seperated files.

The `Samples` folder contains some specially prepared model files:
* The `box.obj` is a cube centered at (0, 0, 0) with a border length of 1, saved in ASCII.
* The `box_uv.png` shows the uv map of `box.obj`.
* The `CM001.primitives` has its content replaced by `box.obj`, it has only one submodel thus only one vertex bloc and one index bloc.
* The `CM001.primitives.root_Propeller_meshShape.0.obj` is extracted from the modified `CM001.primitives`, saved in ASCII. It can help inspecting in which order the vertices & indices are saved in the modified primitives, and their value after eventual convertion.
* `CM001_p2g_0.10.2.geometry` is converted from `CM001.primitives` using WG's geometrypack.exe version 0.10.2, i.e. non re-encoded
* `CM001_p2g_0.11.5.geometry` is converted from `CM001.primitives` using WG's geometrypack.exe version 0.11.5, i.e. vertex and index blocs are re-encoded

We shall first try to decode the binary data in `CM001_p2g_0.11.5.geometry` to get the same data as in `CM001_p2g_0.10.2.geometry`; if successful, it should lead to the same mesh of `CM001.primitives.root_Propeller_meshShape.0.obj`