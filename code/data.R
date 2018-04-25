library(bigrquery)
library(tidyverse)
library(magrittr)
library(ggmap)

dataset <- 'locationHistory'
table <- 'timeline'
project <- 'skilful-sensor-167023'

query <- "
SELECT
  DATE(MSEC_TO_TIMESTAMP(timestampMs)) date,
  REGEXP_REPLACE(LOWER(activity.activity.type), '_', ' ') type,
  COUNT(timestampMs) count
FROM
  [skilful-sensor-167023:locationHistory.timeline]
WHERE
  activity.activity.confidence > 79
GROUP BY
  date,
  type
ORDER BY
  date ASC"

data <- query_exec(query, 
                   project)

data %>% 
  filter(type == 'in vehicle') %>% 
  mutate(date = as.Date(date)) %>% 
  ggplot(aes(date, count)) +
  geom_line(size = 1.5) +
  geom_smooth() +
  facet_wrap(~year(date))