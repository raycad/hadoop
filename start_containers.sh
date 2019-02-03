#!/bin/bash

# The default hadoop cluster has 3 nodes includes 1 master and 2 slaves

# Set the default hadoop slave number is 2
HADOOP_SLAVE_NUMBER=${1:-2}
echo "HADOOP_SLAVE_NUMBER =" $HADOOP_SLAVE_NUMBER

# Start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "Start hadoop-master container in the hadoop network..."
sudo docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
				-p 50075:50075 \
                -p 8088:8088 \
				-e HADOOP_SLAVE_NUMBER=$HADOOP_SLAVE_NUMBER \
                --name hadoop-master \
                --hostname hadoop-master \
                seedotech/hadoop:2.9.2 &> /dev/null

# Start hadoop slave container
i=1
while [ $i -lt $((HADOOP_SLAVE_NUMBER+1)) ]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "Start hadoop-slave$i container..."
	sudo docker run -itd \
	                --net=hadoop \
					-e HADOOP_SLAVE_NUMBER=$HADOOP_SLAVE_NUMBER \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                seedotech/hadoop:2.9.2 &> /dev/null
	i=$(($i+1))
done 

# Get into the hadoop master container
sudo docker exec -it hadoop-master bash
