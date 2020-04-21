#!/bin/bash
##################################################
# Install filebeat                               #
# Author by Dethroner, 2020                      #
##################################################

### Vars
function typev() {
local type1=$1

LSTSH=hd-17496.sam-solutions.net
DIRLOG=/opt/hybris

### Install filebeat
cd /tmp
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.6.2-amd64.deb
dpkg -i filebeat-7.6.2-amd64.deb

### Configure filebeat
echo "" > /etc/filebeat/filebeat.yml

cat <<EOF | sudo tee /etc/filebeat/filebeat.yml
filebeat.inputs:
- type: log
  enabled: true
  paths:
      - $DIRLOG/hybris/log/tomcat/*
  fields:
    type: $type1
  fields_under_root: true
  scan_frequency: 5s

output.logstash:
  hosts: ["$LSTSH:5044"]
EOF

### Start service
systemctl start filebeat
systemctl enable filebeat

}

typev "$1"