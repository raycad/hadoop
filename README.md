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
# Start as the default will create a cluster with 3 nodes included 1 master and 2 slaves
$ sudo ./start_containers.sh

Output:
Start hadoop-master container...
Start hadoop-slave1 container...
Start hadoop-slave2 container...
root@hadoop-master:~#

# Create a cluster has 4 nodes included 1 master and 3 slaves
$ sudo ./start_containers.sh 3
```

##### 4. Start the hadoop cluster from the hadoop master
Get into the hadoop master container then execute the following commands
```
$ cd /root
$ ./start_hadoop.sh
```

##### 5. Verify all the Hadoop services/daemons
```
$ docker exec hadoop-master sh -c "jps"

Output:
161 NameNode
841 Jps
378 SecondaryNameNode
555 ResourceManager
```

##### 6. Run Wordcount in the docker container
```
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

##### 7. Browse the HDFS system
```
http://localhost:50070/explorer.html#
http://localhost:8088/cluster

Check datanode information
(Due to the the HDFS datanode's port 50075 of the slave's containers has been mapped to 2007$i to avoid port conflict. Therefore, instead of accessing to 50075, you will use 20071, 20072,...)

hadoop-slave1
http://localhost:20071

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