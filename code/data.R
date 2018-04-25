library(bigrquery)
library(tidyverse)
library(magrittr)
library(ggmap)

dataset <- 'xxx'
table <- 'xxx'
project <- 'xxx'

dataqery <-
"
SELECT
  latitude,
  longitude,
  date,
  accuracy,
  accuracyLevel,
  ROUND(SUM(timestamp - lag)/60000, 2) minuteDifference,
  activityType,
  activityConfidence,
  CONCAT(STRING(latitude), ', ', STRING(longitude)) latLong,
  CONCAT(REGEXP_EXTRACT(STRING(latitude), '(.*\\d{1,}\\\.\\d{1})'), ', ', REGEXP_EXTRACT(STRING(longitude), '(.*\\d{1,}\\\.\\d{1})')) cityLatLong
FROM (
  SELECT
    longitudeE7/1e7 longitude,
    latitudeE7/1e7 latitude,
    MSEC_TO_TIMESTAMP(timestampMs) date,
    timestampMs timestamp,
    LAG(timestamp) OVER (ORDER BY timestamp ASC) lag,
    accuracy,
    CASE
    WHEN accuracy < 800 THEN 'high'
    WHEN accuracy > 5000 THEN 'low'
    ELSE 'medium'
    END accuracyLevel,
    LOWER(REGEXP_REPLACE(FIRST(activity.activity.type), '_', ' ')) activityType,
    FIRST(activity.activity.confidence) activityConfidence
  FROM
    [xxx.xxx]
  GROUP BY
    longitude,
    latitude,
    date,
    accuracy,
    accuracyLevel,
    timestamp)
GROUP BY
  longitude,
  latitude,
  latLong,
  cityLatLong,
  date,
  accuracy,
  accuracyLevel,
  activityType,
  activityConfidence
ORDER BY
  date ASC"

  data <- query_exec(dataQuery,
                     project,
                     max_pages = Inf)

  ## Questions:
  # How many rows?
  nrow(data)

  # Min date
  min(data$date)

  # Max date
  max(data$date)

  # Top Cities
  cities <- data %>%
    count(cityLatLong, sort = TRUE)

  # Top Locations
  locations <- data %>%
    count(latLong, sort = TRUE)

  # Top Activites
  activities <- data %>%
    count(activityType, sort = TRUE)

  # Activity Confidence
  activityConfidence <- data %>%
    count(activityConfidence, sort = TRUE)

  # Accuracy Level
  dataLevel <- data %>%
    count(accuracyLevel, sort = TRUE)

  # Activity Confidence by Type
  typeConfidence <- data %>%
    group_by(activityType, activityConfidence) %>%
    summarize(n = n()) %>%
    arrange(activityType, desc(activityConfidence))

  # Let's try to geocode some addresses.
  geocodedCity <- cities %>%
    top_n(10, n) %>%
    mutate(address = geocode(cityLatLong,
                             output = 'latlona')$address)
