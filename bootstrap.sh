#!/bin/bash

: ${HADOOP_HOME:=/usr/local/hadoop}

$HADOOP_HOME/etc/hadoop/hadoop-env.sh

# rm /tmp/*.pid

# Installing libraries if any - (resource urls added comma separated to the ACP system variable)
# cd $HADOOP_HOME/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# Replace the HOSTNAME of the $HADOOP_HOME/etc/hadoop/core-site.xml.template file to $HADOOP_MASTER_ADDRESS then copy to the $HADOOP_HOME/etc/hadoop/core-site.xml file
sed s/HADOOP_MASTER_ADDRESS/$HADOOP_MASTER_ADDRESS/ $HADOOP_HOME/etc/hadoop/core-site.xml.template > $HADOOP_HOME/etc/hadoop/core-site.xml

service ssh restart
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
# $HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver

# if [[ $1 == "-d" ]]; then
#   while true; do sleep 1000; done
# fi

# if [[ $1 == "-bash" ]]; then
#   /bin/bash
# fi