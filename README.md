http://odewahn.github.io/docker-jumpstart/building-images-with-dockerfiles.html

https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/ClusterSetup.html
https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/HdfsDesign.html

# Login to Docker Hub
    $ docker login --username=yourhubusername --password=yourpassword

# Build docker image
    $ sudo docker build -t $DOCKER_ACC/$DOCKER_REPO:$IMG_TAG .
E.g.    
    $ sudo docker build -t seedotech/hadoop:2.9.2 .

# Push the image to the docker hub
    $ sudo docker push $DOCKER_ACC/$DOCKER_REPO:$IMG_TAG

# Start a Hadoop container
    $ docker run --name=sdt.hadoop1 -it -p 9000:9000 -p 8020:8020 -p 50010:50010 -p 50020:50020 -p 50070:50070 -p 50075:50075 -e HADOOP_MASTER_ADDRESS=192.168.1.9  
