#!/bin/bash

# The default node number is 3
N=${1:-3}

# Start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "Start hadoop-master container..."
sudo docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
                --name hadoop-master \
                --hostname hadoop-master \
                seedotech/hadoop:2.9.2 &> /dev/null

# Start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "Start hadoop-slave$i container..."
	sudo docker run -itd \
	                --net=hadoop \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                seedotech/hadoop:2.9.2 &> /dev/null
	i=$(( $i + 1 ))
done 

# Get into hadoop master container
sudo docker exec -it hadoop-master bash
