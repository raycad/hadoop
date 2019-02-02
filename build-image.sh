#!/bin/bash

echo -e "\nBuild hadoop 2.9.2 docker image...\n"
sudo docker build -t seedotech/hadoop:2.9.2 .