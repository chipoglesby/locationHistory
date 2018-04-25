library(ggmap)
library(tidyverse)

accuracy %>%
  filter(grepl('^35.5', latitude),
         #activityType == 'on foot',
         grepl('^-82.5', longitude)) %>%
qmplot(data = .,
       longitude,
       latitude,
       maptype = "toner-lite",
       geom = 'point')
