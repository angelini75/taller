# publishing maps of paper 2
rm(list = ls())
name <- function(x) { as.data.frame(names(x))}
#devtools::install_github("tylermorganwall/rayshader")
library(raster)
library(rayshader)
library(rgdal)
library(sf)
library(mapview)
library(leafem)

files <- list.files(path = "/home/marcos/git/rasters/", pattern = "paper2")
r <- stack(paste0("/home/marcos/git/rasters/", files))
names(r) <- c("CIC_hor_A", "CIC_hor_B", "CIC_hor_C",
              "Arcilla_hor_A", "Arcilla_hor_B", "Arcilla_hor_C",
              "COrg_hor_A", "COrg_hor_B", "COrg_hor_C")
mapviewOptions(basemaps = c("Esri.WorldImagery", "OpenStreetMap"))

inta <- "https://inta.gob.ar/sites/all/themes/adaptivetheme/agil/logo.png"
addLogo(map, img = inta, alpha = 1, src = c("remote", "local"),
                position = c("topleft", "topright", "bottomleft", "bottomright"),
                offset.x = 50, offset.y = 13, width = 60, height = 60)



map <- mapview(x = r,
               na.color = "transparent",
               col.regions = mapviewPalette("mapviewTopoColors"),
               query.type = "mousemove",
               query.digits = 1)




#convert it to a matrix:
eldem <- matrix(extract(dem,extent(dem),buffer=1000),
               nrow=ncol(dem),ncol=nrow(dem))
elclay <- matrix(extract(clay,extent(clay),buffer=1000),
                 nrow=ncol(clay),ncol=nrow(clay))
#We use another one of rayshader's built-in textures:
eldem %>%
  sphere_shade(texture = "desert") %>%
  plot_3d(zscale = 20, heightmap = eldem)



gadm  <-  getData(name = "GADM", download = T, country='ARG', level = 1)
dep <- st_as_sf(dep)
gg_nc = ggplot(nc) +
  geom_sf(aes(fill = AREA)) +
  scale_fill_viridis("Area") +
  ggtitle("Area of counties in North Carolina") +
  theme_bw()

plot_gg(gg_nc, multicore = TRUE, width = 6 ,height=2.7, fov = 70)
render_depth(focallength=100,focus=0.72)

