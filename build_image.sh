#!/bin/bash

echo -e "\nBuilding Hadoop 2.9.2 cluster docker image...\n"
sudo docker build -t seedotech/hadoop:2.9.2 .