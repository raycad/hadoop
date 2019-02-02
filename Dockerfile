# Download ubuntu base image 18.10
FROM ubuntu:18.10
LABEL Nguyen Truong Duong<seedotech@gmail.com>

USER root

WORKDIR /usr/local

# Update Ubuntu Software repository
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections
RUN apt-get update
RUN apt-get install -y openssh-server openssh-client curl wget nano openjdk-8-jdk

# Passwordless ssh
RUN yes y | ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN yes y | ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN yes y | ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# Install HADOOP 2.9.2
# https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/ClusterSetup.html
RUN curl -s https://www-eu.apache.org/dist/hadoop/common/hadoop-2.9.2/hadoop-2.9.2.tar.gz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s ./hadoop-2.9.2 hadoop

# Set the Hadoop NameNode Address (the host's IP of the hadoop master container). The default value is $HOSTNAME
ENV HADOOP_MASTER_ADDRESS $HOSTNAME

# Set JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $PATH:$JAVA_HOME/bin
# RUN rm /usr/bin/java && ln -s $JAVA_HOME/bin/java /usr/bin/java

ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_COMMON_HOME $HADOOP_HOME
ENV HADOOP_HDFS_HOME $HADOOP_HOME
ENV HADOOP_MAPRED_HOME $HADOOP_HOME
ENV HADOOP_YARN_HOME $HADOOP_HOME
ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_HOME/etc/hadoop

# RUN echo $HADOOP_MASTER_ADDRESS >> /etc/hosts

# ENTRYPOINT ["/nodejs/bin/npm", "start"]

RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 HADOOP_HOME=/usr/local/hadoop\n:' $HADOOP_HOME/etc/hadoop/hadoop-env.sh
RUN sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/:' $HADOOP_HOME/etc/hadoop/hadoop-env.sh

# RUN mkdir -p $HADOOP_HOME/hdfs/namenode $HADOOP_HOME/hdfs/datanode
RUN mkdir -p $HADOOP_HOME/input $HADOOP_HOME/hdfs/namenode $HADOOP_HOME/hdfs/datanode
RUN cp $HADOOP_HOME/etc/hadoop/*.xml $HADOOP_HOME/input

# Copy the core-site.xml.template file from the host machine to the container
ADD core-site.xml.template $HADOOP_HOME/etc/hadoop/core-site.xml.template
# Replace the HADOOP_MASTER_ADDRESS of the $HADOOP_HOME/etc/hadoop/core-site.xml.template file to $HADOOP_MASTER_ADDRESS then copy to the $HADOOP_HOME/etc/hadoop/core-site.xml file
RUN sed s/HADOOP_MASTER_ADDRESS/$HADOOP_MASTER_ADDRESS/ $HADOOP_HOME/etc/hadoop/core-site.xml.template > $HADOOP_HOME/etc/hadoop/core-site.xml

# Copy the hdfs-site.xml file from the host machine to the container
ADD hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml

ADD mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
ADD yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml

RUN $HADOOP_HOME/bin/hdfs namenode -format

# Fixing the libhadoop.so like a boss
# RUN rm -rf /usr/local/hadoop/lib/native
# RUN mv /tmp/native /usr/local/hadoop/lib

ADD ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENV BOOTSTRAP /etc/bootstrap.sh

# Workingaround docker.io build error
# RUN ls -la $HADOOP_HOME/etc/hadoop/*-env.sh
# RUN chmod +x $HADOOP_HOME/etc/hadoop/*-env.sh
# RUN ls -la $HADOOP_HOME/etc/hadoop/*-env.sh

# Fix the 254 error code
# RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config
# RUN echo "UsePAM no" >> /etc/ssh/sshd_config
# RUN echo "Port 2122" >> /etc/ssh/sshd_config

# RUN service ssh restart && $HADOOP_HOME/etc/hadoop/hadoop-env.sh && $HADOOP_HOME/sbin/start-dfs.sh && $HADOOP_HOME/bin/hdfs dfs -mkdir -p /user/root
# RUN service ssh restart && $HADOOP_HOME/etc/hadoop/hadoop-env.sh && $HADOOP_HOME/sbin/start-dfs.sh && $HADOOP_HOME/bin/hdfs dfs -put $HADOOP_HOME/etc/hadoop/ input

# CMD ["/etc/bootstrap.sh", "-d"]

ENTRYPOINT ["/etc/bootstrap.sh"]

# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000
# Mapred ports
EXPOSE 10020 19888
# Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
# Other ports
EXPOSE 49707 2122