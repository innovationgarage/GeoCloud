# GeoCloud
GeoCloud is a position tracking and track annotation system for ships, based on ElasticSearch.

Pipeline components:

  * [NMEA input service](https://github.com/innovationgarage/GeoCloud-nmea)
  * Annotator services
    * [Weather annotation](https://github.com/innovationgarage/GeoCloud-grib) using [gributils-annotator](https://github.com/innovationgarage/gributils-annotator) connecting to the [gributils-indexer](https://github.com/innovationgarage/gributils) GRIB file repository.
  * [Elastic search inserter](https://github.com/innovationgarage/GeoCloud-es)
 
# Running

    docker-compose up

# Ports & protocols

* This will listen for messages from TinyTracker on port 6024. The TinyTracker protocol is pure NMEA (with tagblocks) over a TCP stream.
* ElasticSearch is available on port 9200 to query tracks. 
* The [GRIB indexer REST protocol](https://github.com/innovationgarage/gributils/blob/master/README.md#rest-usage) is available on port 6028. This can be used to upload weather data to be merged with the tracks.

# ElasticSearch data

  * Two Elastic Search indices
    * Positional data
    * Non-positional data
  * [GeoJSON](https://geojson.org/) point with properties containing GPSD JSON
    * Encoded in ES as GeoPoint
