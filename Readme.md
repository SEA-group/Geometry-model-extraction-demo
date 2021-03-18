# Geometry format coding research

![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/SEA-group/Geometry-model-extraction-demo?include_prereleases)
![GitHub last commit](https://img.shields.io/github/last-commit/SEA-group/Geometry-model-extraction-demo)
![GitHub issues](https://img.shields.io/github/issues-raw/SEA-group/Geometry-model-extraction-demo)
![GitHub pull requests](https://img.shields.io/github/issues-pr-raw/SEA-group/Geometry-model-extraction-demo)

## Purpose
This repo stocks files that may help understanding the file strcture of *.geometry* format. 
`format` folder contains vertex types' information, extracted from WoWS client.
`Geometry Samples` folder contains some model files in both *.primitives* and *.geometry* format, that may help the research in different ways:
* The shell files (`CPA00x`) have only 1 detail level (lod0) and 3 model parts; the propeller files (`CM001 to CM003`) have 1 model part and 3 lods. They use only one vertex type (xyznuvtbpc) and one index type (list16). They're simple therefore easy to get start with.
* `FSB013_Jean_Bart_1955_MidBack` has a rich variety of vertex types (xyznuvpc for glass window, xyznuvrpc for wire, xyznuvtbpc for the rest) and both list16 & list32 index types.
* `AGS028`, `JAS007` and `JGM055` can be used for investigating vertex types with iiiww.

## Shell model convertor
~~It seems that *.geometry* has less information then *.primitives*, I guess WG's tool would need their corresponding *.visual* file for the conversion. Meanwhile we have never had *.visual* files of the shells.~~(Proven false) Since those models look simple, I will try to make a tool by myself.

The first version is completed, ~~but I can't test it since the PT server is offline.~~ Test done, the tool is functional.

## IM200 convertor
Modified version of Shell model convertor, for Kobayashi's water heater. But it doesn't work (Nevermind, WG's conversion tool is up now)

## Geometry to obj convertor
...is planned for the future, when we have fully understood the new format.
