accuracyQuery <-
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
    [locationHistory.timeline]
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

accuracy <- query_exec(accuracyQuery, 
                   project,
                   max_pages = Inf)

## Questions:

# How many rows?
nrow(accuracy)

# Min date
min(accuracy$date)

# Max date
max(accuracy$date)

# Top Cities
cities <- accuracy %>%
  count(cityLatLong, sort = TRUE)

# Top Locations
locations <- accuracy %>%
  count(latLong, sort = TRUE)

# Top Activites
activities <- accuracy %>%
  count(activityType, sort = TRUE)

# Activity Confidence
activityConfidence <- accuracy %>%
  count(activityConfidence, sort = TRUE)

# Accuracy Level
accuracyLevel <- accuracy %>% 
  count(accuracyLevel, sort = TRUE)

# Activity Confidence by Type
typeConfidence <- accuracy %>%
  group_by(activityType, activityConfidence) %>%
  summarize(n = n()) %>% 
  arrange(activityType, desc(activityConfidence))


test <- cities %>%
  top_n(10, n) %>% 
  mutate(address = geocode(cityLatLong,
                           output = 'latlona')$address)

accuracy %>% 
  count(difference, sort = TRUE)