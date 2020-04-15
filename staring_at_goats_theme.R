library(ggplot2)
library(scales)

palette_sag= c("#7fc7af",
               "#808EE0",
               "#CB8261",
               "#005A32",
               "#E8F3F1",
               "#545479",
               "#99B0A8",
               "#817FB0",
               "#BA9A55",
               "#F0EDFF",
               "#4A917B",
               "#8CBEEC")

oldopts = options() 
options(ggplot2.continuous.colour=palette_sag)
options(ggplot2.continuous.fill=palette_sag)

scale_colour_discrete <- function(...) {
  scale_colour_manual(..., values = palette_sag)
}

scale_fill_discrete <- function(...) {
  scale_fill_manual(..., values = palette_sag)
}


staring_at_games_theme = theme_light() +
  theme(legend.title = element_blank()) +
  theme(legend.key.size = unit(1,"cm")) +
  theme(legend.background=element_rect(fill="transparent",colour=NA)) +
  theme(legend.key = element_rect(fill="transparent",colour=NA))+
  theme(axis.text.x = element_text(colour = 'black', size = 9),
        axis.title.x=element_text(size=12, colour = 'black')) +
  theme(axis.text.y = element_text(colour = 'black', size = 9), 
        axis.title.y = element_text(size = 12)) +
  theme(panel.background = element_rect(fill = "#f9f9f9")) +
  theme(plot.background = element_rect(fill = "#f9f9f9"))
