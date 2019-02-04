### A. Create Docker Image
##### 1. Login to Docker Hub
```
$ docker login --username=yourhubusername --password=yourpassword
```

##### 2. Build docker image
```
$ ./build_image.sh
```

##### 3. Push the image to the docker hub
```
$ sudo docker push $DOCKER_ACC/$DOCKER_REPO:$IMG_TAG

e.g
$ sudo docker push seedotech/hadoop:2.9.2
```

### B. Pull and Start Hadoop cluster
##### 1. Pull the image
```
$ sudo docker pull seedotech/hadoop:2.9.2
```

##### 2. Create a hadoop network
```
$ sudo docker network create --driver=bridge hadoop
```

##### 3. Start hadoop containers
```
# The 1st argument is set to YES if you want to create a master, the default is YES
# The 2nd argument is the number of slaves you want to create, the default is 2
# Start as the default will create a cluster with 3 nodes included 1 master and 2 slaves
$ sudo ./start_containers.sh

Output:
Start hadoop-master container...
Start hadoop-slave1 container...
Start hadoop-slave2 container...
root@hadoop-master:~#

# Create a cluster has 4 nodes included 1 master and 3 slaves
$ sudo ./start_containers.sh YES 3

# Create a cluster has 3 nodes included 3 slaves (no hadoop master)
$ sudo ./start_containers.sh NO 3
```

##### 4. Verify all the Hadoop services/daemons
```
$ docker exec hadoop-master sh -c "jps"

Output:
161 NameNode
841 Jps
378 SecondaryNameNode
555 ResourceManager
```

##### 5. Run Wordcount in the docker container
```
# Get into the container
$ sudo docker exec -it hadoop-master bash
$ ./run_wordcount.sh
```

Output
```
Input file1.txt:
Hello Docker
Input file2.txt:
Hello Hadoop

Wordcount output:
Docker  1
Hadoop  1
Hello   2
```

##### 6. Browse the HDFS system
```
http://localhost:50070/explorer.html#
http://localhost:8088/cluster

Check datanode information
(To avoid port conflict in the same host machine, the 1st hadoop slave port is mapped to 50075. From the other slaves the port is mapped to 2007$i, e.g 20072, 20073,...)

hadoop-slave1
http://localhost:50075

hadoop-slave2
http://localhost:20072
```

**NOTE**

You might not upload files to the hadoop cluster via HDFS Web browser. It's due to the cluster will call to http://hadoop-slave1:50075 to process while your machine could not recorgnize the "hadoop-slave1" address. To fix this you have to register the Hadoop Slave address to the hosts file:
```
$ sudo nano /etc/hosts

Then add the following lines:
# Set host for Hadoop cluster
192.168.1.8 hadoop-master
192.168.1.6 hadoop-slave1
192.168.1.5 hadoop-slave2
```

### C. References
```
http://odewahn.github.io/docker-jumpstart/building-images-with-dockerfiles.html

https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/ClusterSetup.html
https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/HdfsDesign.html
```