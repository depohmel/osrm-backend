#! /usr/bin/ash
set -o errexit
set -o xtrace

if ! [ -e /data ]; then
    echo "/data volume is not present, Please mount it"
    exit 1
fi

case $(ls /data/*osm.pbf | wc -l) in
    0)
    echo "Skipping extract"
    ;;
    1)
    file=$(ls /data/*osm.pbf)
    osrm-extract -p /opt/car.lua  $file
    mv  ${file} ${file}-done
    ;;
    *)
    echo "osrm-extract doesn't work for multiple files"
    exit 1
    ;;
esac

case $(ls /data/*osrm | wc -l) in
    1)
    file=$(ls /data/*osrm)
    osrm-partition ${file}
    osrm-customize ${file}
    ;;
    *)
    echo "Atleast 1 osrm needs to be present"
    exit 1
    ;;
esac

osrm-routed --algorithm mld $(ls /data/*osrm)
