library(googlesheets4)
library(ggplot2)
library(scales)
library(dplyr)

source("staring_at_goats_theme.R")

#colour palette
show_col(palette_sag)

# Source Data from Net Market Share: https://netmarketshare.com/operating-system-market-share.aspx
# Data was downloaded to a googlesheet for ease of data wrangling
netmarketshare = read_sheet("https://docs.google.com/spreadsheets/d/174mT2MrqxfJWmK54SHbjnAehInv_gbNrVdUj_YWHDmE",
                            sheet=2)

# https://gs.statcounter.com/os-market-share/desktop/worldwide/2019

netmarketshare_clean = netmarketshare %>% 
  mutate(platform_group = ifelse(Platform %in% c("Windows", "Mac OS", "Linux"),
                                 Platform,
                                 "Other")) %>% 
  group_by(platform_group, Year) %>% 
  summarise(Share=sum(Share)) %>% 
  ungroup()

netmarketshare_clean %>% 
  ggplot(aes(y=Share, x=Year, colour=platform_group)) +
  geom_line(size=1.2)+ 
  guides(colour = guide_legend(override.aes = list(size=4),
                               label.hjust = 0.5)) + 
  staring_at_games_theme





netmarketshare %>% 
  ggplot(aes(y=Share, x=Year, fill=Platform)) +
  #geom_line(size=1.2)+ 
  geom_bar(stat = "identity", position = "dodge2")+
  guides(fill = guide_legend(override.aes = list(size=4),
                             label.hjust = 0.5)) + 
  staring_at_games_theme



