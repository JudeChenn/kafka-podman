podman network create kafka-network
podman run -d -p 9091:19091 --name mykafka1 --network kafka-network --privileged --tmpfs /tmp --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add=SYS_ADMIN centos:8 /usr/sbin/init
podman exec -it mykafka1 /bin/bash

cd /etc/yum.repos.d/
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
cd ~

dnf install java-17-openjdk java-17-openjdk-devel
java -version

yum install -y wget
wget https://archive.apache.org/dist/kafka/3.1.0/kafka_2.13-3.1.0.tgz
tar xzf kafka_2.13-3.1.0.tgz

vi ~/.bashrc
export PATH="$PATH:~/kafka_2.13-3.0.0/bin"

source ~/.bashrc
echo $PATH

vi ~/kafka_2.13-3.1.0/config/server.properties
broker.id=1
listeners=INTERNAL://0.0.0.0:9092,EXTERNAL://0.0.0.0:19091
advertised.listeners=INTERNAL://mykafka1:9092,EXTERNAL://localhost:9091
listener.security.protocol.map=INTERNAL:PLAINTEXT,EXTERNAL:PLAINTEXT
inter.broker.listener.name=INTERNAL
zookeeper.connect=localhost:2181

min.insync.replicas=1
default.replication.factor=1


vi /etc/systemd/system/zookeeper.service
==================================================
[Unit]
Description=Apache ZooKeeper
After=network.target

[Service]
Type=simple
#User=zookeeper
#Group=zookeeper
ExecStart=/root/kafka_2.13-3.1.0/bin/zookeeper-server-start.sh /root/kafka_2.13-3.1.0/config/zookeeper.properties
ExecStop=/root/kafka_2.13-3.1.0/bin/zookeeper-server-stop.sh
Restart=on-failure
RestartSec=5
LimitNOFILE=100000

[Install]
WantedBy=multi-user.target
==================================================
systemctl daemon-reload
systemctl start zookeeper
systemctl status zookeeper




vi /etc/systemd/system/kafka.service
==================================================
[Unit]
Description=Apache Kafka
After=network.target zookeeper.service
Wants=zookeeper.service

[Service]
Type=simple
#User=kafka
#Group=kafka
ExecStart=/root/kafka_2.13-3.1.0/bin/kafka-server-start.sh /root/kafka_2.13-3.1.0/config/server.properties
ExecStop=/root/kafka_2.13-3.1.0/bin/kafka-server-stop.sh
Restart=on-failure
RestartSec=5
LimitNOFILE=100000

[Install]
WantedBy=multi-user.target
==================================================
systemctl daemon-reload
systemctl start kafka
systemctl status kafka
