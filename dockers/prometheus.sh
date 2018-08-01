#!/usr/bin/env bash

docker rm -f prometheus
docker run -d -p 9090:9090 --name prometheus -v ~/dev/scripts/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/prometheus
