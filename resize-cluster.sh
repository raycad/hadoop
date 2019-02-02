#!/bin/bash

# N is the node number of hadoop cluster
N=$1

if [ $# = 0 ]
then
	echo "Please specify the node number of hadoop cluster!"
	exit 1
fi

# Change slaves file
i=1
rm config/slaves
while [ $i -lt $N ]
do
	echo "hadoop-slave$i" >> config/slaves
	((i++))
done 

echo ""

echo -e "\nBuild docker hadoop image\n"

# Rebuild seedotech/hadoop image
sudo docker build -t seedotech/hadoop:2.9.2 .

echo "DONE..."
