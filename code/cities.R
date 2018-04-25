library(ggmap)
library(magrittr)
library(tidyverse)
library(stringr)

cities <- accuracy %>% 
  group_by(latLong) %>% 
  mutate(final = paste(str_extract(latitude, '\\d{1,}\\.\\d{2}'), 
                       str_extract(longitude, '\\d{1,}\\.\\d{2}'),
                       sep = ', ')) %>% 
  ungroup() %>% 
  count(final, sort = TRUE) %>% 
  mutate(address = geocode(final,
                           output = 'latlona')$address)