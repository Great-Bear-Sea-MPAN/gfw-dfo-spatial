# GFW–DFO Spatial Analysis

This repository contains scripts for analyzing Global Fishing Watch (GFW) and DFO gridded commercial fishing data. The project is ongoing this repo may be expanded as new analyses and datasets are added.

## Project structure

- `scripts/`  
  R scripts for processing and analyzing spatial data, including grid generation and data preparation.

- `data/raw/`  
  Original input datasets (e.g., DFO gridded commercial fishing data). These are not modified.

- `data/processed/`  
  Outputs generated from scripts, including spatial grids and derived datasets. Large files in this folder (e.g., GeoPackages) are excluded from GitHub due to file size limits and are generated locally when needed.

## Notes

Some processed spatial files exceed GitHub’s 100 MB file size limit and are not included in version control. These are created locally by running the relevant scripts in `scripts/`.
The resulting file is also currently saved on [Google Drive](https://drive.google.com/file/d/12zH806_dnYu_WvobgfZ7dmTS6_66HlF4/view?usp=drive_link).

## Current work

- Generating a continuous 1 km spatial grid from DFO gridded fishing data
