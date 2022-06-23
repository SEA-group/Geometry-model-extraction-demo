# Geometry format coding research

![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/SEA-group/Geometry-model-extraction-demo?include_prereleases)
![GitHub last commit](https://img.shields.io/github/last-commit/SEA-group/Geometry-model-extraction-demo)
![GitHub issues](https://img.shields.io/github/issues-raw/SEA-group/Geometry-model-extraction-demo)
![GitHub pull requests](https://img.shields.io/github/issues-pr-raw/SEA-group/Geometry-model-extraction-demo)

## Purpose
This repo stocks files that may help understanding the file strcture of *.geometry* format.

The `format` folder contains vertex types' information, extracted from WoWS client.

The `Geometry Samples` folder contains some model files in both *.primitives* and *.geometry* format, that may help the research in different ways:
* The shell files (`CPA00x`) have only 1 detail level (lod0) and 3 model parts; the propeller files (`CM001 to CM003`) have 1 model part and 3 lods. They use only one vertex type (xyznuvtbpc) and one index type (list16). They're simple therefore easy to get start with.
* `FSB013_Jean_Bart_1955_MidBack` has a rich variety of vertex types (xyznuvpc for glass window, xyznuvrpc for wire, xyznuvtbpc for the rest) and both list16 & list32 index types.
* `AGS028`, `JAS007` and `JGM055` can be used for investigating vertex types with iiiww.
* Some *.geometry* files have surfix: "0.10.2" means they're extracted from 0.10.2 game file; "0.10.11" means extracted from 0.10.11 game file; "p2g_0.10.2" means they're converted from 0.9.7 *.primitives* file, with WG's tool version 0.10.2; "p2g_0.10.11" idem.

The `Extractor` folder contains the *.geometry* to *.obj* convertor demo itself. 

## Progress
The coding of cmodl and armor sections is yet unclear for now, but those sections are "inert", they don't interfer with other sections. If our goal is to make a model conversion/extraction tool, we don't need to touch them at all. 

The last remaining problem is the name of the vertices/indices blocs, how WG encrypt a string with random length into 4 bytes.

## Geometry to obj convertor
The first functional version is done. **It only works on old *.geometry* files extracted from 0.10.2 to approximatively 0.11.3** becasue WG has started to encode the models with mesh optimizer. Although the file extention remains the same, the data are now coded in another way.

To use those scripts, put your *.geometry* files in *Queue/*, run `GeometryExtractor_Mk1.m`, and wait obj files to be generated in `Extract` folder. Since we still not know how to read the models' name, The index and vertex blocs are paired according to number of vertices. When multiple vertex blocs have same number of vertices, all possible combinations will be saved.
