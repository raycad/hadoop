# Download ubuntu base image 18.10
FROM ubuntu:18.10
LABEL Nguyen Truong Duong<seedotech@gmail.com>

WORKDIR /root

# Install openssh-server, openjdk and wget
RUN apt-get update && apt-get install -y openssh-server openjdk-8-jdk wget nano iputils-ping net-tools telnet

# Install HADOOP 2.9.2
RUN wget https://www-eu.apache.org/dist/hadoop/common/hadoop-2.9.2/hadoop-2.9.2.tar.gz && \
    tar -xzvf hadoop-2.9.2.tar.gz && \
    mv hadoop-2.9.2 /usr/local/hadoop && \
    rm hadoop-2.9.2.tar.gz

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/usr/local/hadoop 
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin 
# Define the hadoop slaves in the hadoop cluster
ENV HADOOP_SLAVE_NUMBER 2

# ssh without key
RUN ssh-keygen -t rsa -f /root/.ssh/id_rsa -P '' && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

# Create the default directories
RUN mkdir -p /root/hdfs/namenode && \ 
    mkdir -p /root/hdfs/datanode && \
    mkdir -p /root/hdfs/hadooptmp && \
    mkdir $HADOOP_HOME/logs

# Copy resources from the host to the docker container
ADD config/ssh_config /root/.ssh/config
ADD config/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh
ADD config/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
ADD config/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
ADD config/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
ADD config/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
ADD config/slaves $HADOOP_HOME/etc/hadoop/slaves
ADD config/start_hadoop.sh /root/start_hadoop.sh
ADD config/run_wordcount.sh /root/run_wordcount.sh

RUN chmod +x /root/start_hadoop.sh && \
    chmod +x /root/run_wordcount.sh && \
    chmod +x $HADOOP_HOME/etc/hadoop/slaves && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh 

# Format namenode
RUN $HADOOP_HOME/bin/hdfs namenode -format

# Start services
# CMD service ssh start && /root/start_hadoop.sh
CMD [ "sh", "-c", "service ssh start; bash"]

# # HDFS ports
# EXPOSE 50010 50020 50070 50075 50090 8020 9000
# # Mapred ports
# EXPOSE 10020 19888
# # Yarn ports
# EXPOSE 8030 8031 8032 8033 8040 8042 8088