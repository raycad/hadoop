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
```

##### 4. Create hadoop network
```
$ sudo docker network create --driver=bridge hadoop
```

##### 5. Start hadoop containers
```
# Start as the default will create a cluster with 3 nodes included 1 master and 2 slaves
$ ./start_containers.sh

**Output:**
Start hadoop-master container...
Start hadoop-slave1 container...
Start hadoop-slave2 container...
root@hadoop-master:~#

# Create a cluster has 4 nodes included 1 master and 3 slaves
$ ./start_containers.sh 3
```

##### 6. Start hadoop cluster in the hadoop master
Get into the hadoop master container then execute the following commands
```
$ cd /root
$ ./start-hadoop.sh
```

##### 7. Verify all the Hadoop services/daemons
```
$ jps

**Output:**
root@hadoop-master:~# jps
161 NameNode
841 Jps
378 SecondaryNameNode
555 ResourceManager
```

##### 8. Run Wordcount in the docker container
```
$ ./run_wordcount.sh
```

**Output**
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

##### References
```
https://github.com/kiwenlau/hadoop-cluster-docker/blob/master/Dockerfile
http://odewahn.github.io/docker-jumpstart/building-images-with-dockerfiles.html

https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/ClusterSetup.html
https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/HdfsDesign.html
```