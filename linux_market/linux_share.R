library(googlesheets4)
library(ggplot2)
library(scales)
library(dplyr)
library(tidyr)
library(lubridate)
library(zoo)

# Set Environment ----------------------------------
setwd("~/staringatgames/linux_market")
source("~/staringatgames/staring_at_goats_theme.R")


# Get Data -----------------------------------------
data_sheet = "https://docs.google.com/spreadsheets/d/174mT2MrqxfJWmK54SHbjnAehInv_gbNrVdUj_YWHDmE"

newzoo_data = read_sheet(data_sheet,
                            sheet=1)

steam_hardware_data = read_sheet(data_sheet,
                                 sheet=2)

stack_overflow_data = read_sheet(data_sheet,
                                 sheet=4)

netmarketshare_data = read_sheet(data_sheet,
                             sheet=5)


# Clean the data ----------------------------------------------------
# Data is formatted and transformed into a format that is easier to
# join and use in ggplot.

newzoo_clean = newzoo_data %>% 
  transmute(year = Year,
            pc_market = `PC Market (excluding browser games)`,
            total_market = `Total Market`,
            gamers = Gamers,
            # Using the survey proxy of 52% being PC gamers
            pc_gamers = gamers*0.52) %>% 
  pivot_longer(-year)

steam_hardware_clean = steam_hardware_data %>% 
  mutate(Month = as.Date(ifelse(month(Month)> 6, as.Date(Month + years(1)), as.Date(Month) ))) %>% 
  transmute(year = format(Month, "%Y"),
            windows = `Microsoft Windows`,
            mac = `Mac OS`,
            linux = Linux,
            other = Other) %>% 
  pivot_longer(-year,names_to = "platform", values_to = "share") %>% 
  mutate(data_source = "steam")

stack_overflow_clean = stack_overflow_data %>% 
  transmute(year = Year,
            windows = `Windows Share`,
            mac = `Mac Share`,
            linux = `Linux Share`,
            other = Other) %>% 
  pivot_longer(-year,names_to = "platform", values_to = "share") %>% 
  mutate(data_source = "stack_overflow")

netmarketshare_clean = netmarketshare_data %>% 
  transmute(platform = case_when(Platform == "Windows" ~ "windows",
                                 Platform == "Mac OS" ~ "mac",
                                 Platform == "Linux" ~ "linux",
                                 TRUE ~ "other"
                                  ),
            year = Year,
            share=Share/100) %>% 
  group_by(year,platform) %>% 
  summarise(share=sum(share)) %>% 
  ungroup() %>% 
  mutate(data_source = "netmarketshare")


# Create main data frame ------------------------------
platform_share = steam_hardware_clean %>% 
  union_all(stack_overflow_clean) %>% 
  



 %>% 
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



