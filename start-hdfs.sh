#!/bin/bash
if [ ! -d "/usr/local/hadoop/data/namenode/current" ]; then
    echo "Formatting NameNode..."
    hdfs namenode -format
fi
hdfs namenode
