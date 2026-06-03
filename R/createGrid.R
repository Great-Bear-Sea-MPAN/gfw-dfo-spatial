################################################################################
## R Code for Generating a Continuous Spatial Grid from
## DFO Gridded Commercial Fishing Data
##
## Created by Stephen Finnis
## June 2, 2026
##
## NOTE:
## Output GeoPackage is too large for GitHub (>100 MB file size limit) and is
## excluded from version control (added to .gitignore). It must be generated
## locally by running this script.
##
## DFO gridded fishing datasets only contain cells with observations. Areas with
## no observations are not represented as grid cells. This script generates a
## continuous 1 km grid covering the full spatial extent of the dataset.
##
## Workflow:
## - Reads in the original DFO gridded dataset
## - Generates a continuous 1 km grid using st_make_grid()
## - Writes output as a GeoPackage for local use
################################################################################

# Install and load packages
packages = c("sf", "dplyr", "here", "ggplot2", "arcpullr")

installed = packages %in% rownames(installed.packages())
if (any(!installed)) {
  install.packages(packages[!installed])
}

lapply(packages, library, character.only = TRUE)

################################################################################

# Path to downloaded geodatabase
# Source:
# https://open.canada.ca/data/en/dataset/a91e5a18-59f7-49ce-aa14-6f12c9f928ef 
# I downloaded the geodatabase option
gdb_path = here("data", "raw", "DFO Gridded Commercial Fishing Data – Various Years_20220303.gdb")

# Read in original gridded fishing dataset
# Layer of interest: all_fisheries_filtered_gridded
# This layer contains only cells with observations and is used to define the
# spatial extent of the continuous grid.
grid = st_read(
  gdb_path,
  layer = "all_fisheries_filtered_gridded",
  quiet = TRUE
)

# Generate continuous 1 km grid covering the full extent of the dataset
full_grid = st_make_grid(
  st_as_sfc(st_bbox(grid)),
  cellsize = 1000 # units are in meters (i.e., 1 km)
) %>%
  st_sf()

# Assign CRS from source dataset
st_crs(full_grid) = st_crs(grid)

# Export continuous grid as GeoPackage
st_write(
  full_grid,
  here("data", "processed", "full_fishing_grid_1km.gpkg"),
  delete_dsn = TRUE
)

# Note, you can visualize the data in R to ensure there is correct overlap of the cells
# (from the new full_fishing_grid_1km dataset, and then originally gridded data)
# But R can be slow mapping high-res datasets. Easier to view in Arc or Q instead