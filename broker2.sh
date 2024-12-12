podman run -d -p 9092:19092 --name mykafka2 --network kafka-network --privileged --tmpfs /tmp --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add=SYS_ADMIN centos:8 /usr/sbin/init
podman exec -it mykafka2 /bin/bash

vi ~/kafka_2.13-3.1.0/config/server.properties
broker.id=2
listeners=INTERNAL://0.0.0.0:9092,EXTERNAL://0.0.0.0:19092
advertised.listeners=INTERNAL://mykafka2:9092,EXTERNAL://localhost:9092
listener.security.protocol.map=INTERNAL:PLAINTEXT,EXTERNAL:PLAINTEXT
inter.broker.listener.name=INTERNAL
zookeeper.connect=mykafka1:2181

vi /etc/systemd/system/kafka.service
==================================================
[Unit]
Description=Apache Kafka
After=network.target

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
