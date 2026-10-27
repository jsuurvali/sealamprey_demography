# creates a map of sampling locations

library(tidyverse)
library(mapdata)

Lat <- as.numeric(c(
  "44.33953",
  "44.06106",
  "44.33788",
  "44.30761",
  "44.392381",
  "42.451509",
  "42.384627",
  "41.76030816",
  "42.602219",
  "44.028208",
  "46.252611",
  "45.65651",
  "46.50686",
  "43.058065",
  "45.9483086",
  "43.9941",
  "43.816767",
  "46.6903083",
  "46.46530864",
  "46.55500876",
  "46.692742",
  "41.28477",
  "39.6748228",
  "39.6909291",
  "39.134949",
  "34.9228",
  "34.85627",
  "35.349",
  "36.3287",
  "36.475105",
  "36.47712",
  "35.9554"
  ))

Lon <- as.numeric(c(
  "-73.093",
  "-73.26953",
  "-73.09912",
  "-73.12638",
  "-73.11921",
  "-76.510901",
  "-76.863564",
  "-81.28080382",
  "-80.45191",
  "-83.682204",
  "-83.560831",
  "-84.46507",
  "-84.342001",
  "-86.250187",
  "-86.24570579",
  "-76.0638",
  "-79.034742",
  "-91.827508",
  "-86.91530606",
  "-85.02940548",
  "-64.842909",
  "-72.342589",
  "-76.4511499",
  "-76.4265029",
  "-76.82557",
  "-80.01853",
  "-79.91677",
  "-78.1501",
  "-77.5781",
  "-77.640325",
  "-77.63972",
  "-77.7807"
  ))

Source <- c(c(rep("#88CDD8", 5), rep("tomato", 2), rep("darkseagreen4", 8), rep("orange", 2), rep("darkseagreen4", 3), rep("grey30", 12)))
coords <- data.frame(Lat, Lon, Source)

usa <- map_data("usa")
canada <- map_data("worldHires", "Canada")
map1 <- ggplot() +
  geom_polygon(data = usa, aes(x=long, y = lat, group = group),fill = "white", color="black", linewidth = 1) +
  geom_polygon(data = canada, aes(x=long, y = lat, group = group), fill = "white", color="black", linewidth = 1) + 
  coord_fixed(xlim = c(-95, -60),  ylim = c(30, 50)) +
  geom_point(data=coords, aes(x=Lon, y=Lat), pch=21, color = "black", fill = factor(Source), stroke = 1, size = 20) +
  theme(panel.background = element_rect(fill = '#9ec2db', color = '#9ec2db'),
        panel.border = element_rect(color = "black", fill = NA, linewidth = 1.5),
        text = element_text(size = 48),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.x=element_text(colour="black"),
        axis.text.y=element_text(colour="black"),
        panel.grid.minor.y = element_blank()) +
  scale_y_continuous(position = "right")

pdf("samplingsites.pdf", width = 15, height = 9)
map1
dev.off()
