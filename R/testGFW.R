# Check/install remotes
if (!require("remotes"))
  install.packages("remotes")

remotes::install_github("GlobalFishingWatch/gfwr",
                        dependencies = TRUE)

library(gfwr)


testVessel = gfw_vessel_info(query = 224224000,
                search_type = "search")


# fishing events in user shapefile
test_polygon <- sf::st_bbox(c(xmin = -70,
                              xmax = -40,
                              ymin = -10,
                              ymax = 5),
                            crs = 4326) |>
  sf::st_as_sfc() |>
  sf::st_as_sf()


events = gfw_event(event_type = "FISHING",
          start_date = "2020-10-01",
          end_date = "2020-10-31",
          region = test_polygon,
          region_source = "USER_SHAPEFILE")

str(events)

events_sf <- st_as_sf(
  events,
  coords = c("lon", "lat"),
  crs = 4326
)


library(sf)
library(ggplot2)
library(rnaturalearth)

world <- ne_countries(
  scale = "medium",
  returnclass = "sf"
)

ggplot() +
  geom_sf(data = world,
          fill = "grey90",
          colour = "grey70") +
  geom_sf(data = events_sf,
          colour = "blue",
          alpha = 0.4,
          size = 0.6) +
  geom_sf(data = test_polygon,
          fill = NA,
          colour = "red",
          linewidth = 1) +
  coord_sf(
    xlim = c(-70, -40),
    ylim = c(-10, 5)
  ) +
  theme_minimal() +
  labs(
    title = "Fishing Events",
    subtitle = "Global Fishing Watch"
  )



names(events)




library(sf)
library(purrr)

library(sf)
library(purrr)

bbox_polys <- map(events$boundingBox, function(bb) {
  
  xmin <- min(bb[[1]], bb[[3]])
  xmax <- max(bb[[1]], bb[[3]])
  ymin <- min(bb[[2]], bb[[4]])
  ymax <- max(bb[[2]], bb[[4]])
  
  st_polygon(list(matrix(
    c(
      xmin, ymin,
      xmax, ymin,
      xmax, ymax,
      xmin, ymax,
      xmin, ymin
    ),
    ncol = 2,
    byrow = TRUE
  )))
})

bbox_sf <- st_sf(
  geometry = st_sfc(bbox_polys, crs = 4326)
)
