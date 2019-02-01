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
