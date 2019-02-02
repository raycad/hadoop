http://odewahn.github.io/docker-jumpstart/building-images-with-dockerfiles.html

https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/ClusterSetup.html
https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/HdfsDesign.html

### A. Guidelines
##### 1. Login to Docker Hub
```
$ docker login --username=yourhubusername --password=yourpassword
```

##### 2. Build docker image
```
$ ./build-image.sh
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
$ ./start-container.sh
```

**Output:**
```
start hadoop-master container...
start hadoop-slave1 container...
start hadoop-slave2 container...
root@hadoop-master:~# 
```

- Start 3 containers with 1 master and 2 slaves
- You will get into the /root directory of hadoop-master container

##### 6. Start hadoop
```
$ ./start-hadoop.sh
```

##### 7. Run wordcount
```
$ ./run-wordcount.sh
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

### B. Arbitrary size hadoop cluster

##### 1. Pull docker images and clone github repository
```
$ sudo docker pull seedotech/hadoop:2.9.2
```

##### 2. Rebuild docker image
```
$ sudo ./resize-cluster.sh 5
```
- Specify parameter > 1: 2, 3...
- This script just rebuild hadoop image with different **slaves** file, which pecifies the name of all slave nodes

##### 3. Start container
```
$ sudo ./start-container.sh 5
```

- Use the same parameter as the step 2

##### 4. Run hadoop cluster 
do 5~6 like section A