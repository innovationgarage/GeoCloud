#! /bin/bash

set -x

screen -S geocloud -d -m bash
cat > /tmp/geocloud-nmea.conf <<EOF
    {
        "connections": [
            {"handler": "source", "type": "listen", "address": "tcp:1024"},
            {"handler": "destination", "type": "listen", "address": "tcp:1025"}
        ]
    }    
EOF
screen -t Parser -X -S geocloud screen geocloud-nmea /tmp/geocloud-nmea.conf

# {"handler": "source", "type": "connect", "address": "tcp:153.44.253.27:5631"},

cat > /tmp/gributils-annotator.conf <<EOF
    {
        "index": "http://localhost:1028",
        "connections": [
            {"handler": "source", "type": "connect", "address": "tcp:localhost:1025"},
            {"handler": "destination", "type": "listen", "address": "tcp:1026"}
        ]
    }
EOF
screen -t Annotator -X -S geocloud screen gributils-annotator --config /tmp/gributils-annotator.conf

cat > /tmp/geocloud-es.conf <<EOF
    {
        "es_host" : "167.99.194.243:9200",
        "connections": [
            {"handler": "source", "type": "connect", "address": "tcp:localhost:1026"}
        ],
        "vessels_index": "",
        "vessels_mapping": {
            "mappings" : {
                "_doc": {
                    "properties" : {
                        "mmsi": {
                            "type": "text"
                        }
                    }
                }
            }
        },    
        "positions_index": "",
        "positions_mapping": {
            "mappings" : {
                "_doc": {
                    "properties" : {
                        "location": {
                            "type": "geo_shape"
                        },
                        "mmsi": {
                            "type": "text"
                        }
                    }
                }
            }
        }            
    }
EOF
screen -t ES-ingestor -X -S geocloud screen geocloud-es /tmp/geocloud-es.conf

screen -t GRIB-server -X -S geocloud screen gributils server --database="http://167.99.194.243:9200"

screen -r geocloud
