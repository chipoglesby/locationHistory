SELECT
  latitude,
  longitude,
  date (69.0 *
    DEGREES(ACOS(COS(RADIANS(latitudeLag)) *
    COS(RADIANS(latitude)) *
    COS(RADIANS(longitudeLag) -
    RADIANS(longitude)) +
    SIN(RADIANS(latitudeLag)) *
    SIN(RADIANS(latitude))))) haversineDistance,
FROM (
  SELECT
    date,
    latitudeE7,
    latitude,
    longitudeE7 longitude,
    LAG(latitude) OVER (ORDER BY date ASC) latitudeLag,
    LAG(longitude) OVER (ORDER BY date ASC) longitudeLag
  FROM
    // Change your table name below
    [xxx.xxx])
ORDER BY
  date ASC
LIMIT
  10
