podman run -d -p 9093:19093 --name mykafka3 --network kafka-network --privileged --tmpfs /tmp --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add=SYS_ADMIN centos:8 /usr/sbin/init
podman exec -it myafka3 /bin/bash

vi ~/kafka_2.13-3.1.0/config/server.properties
broker.id=3
listeners=INTERNAL://0.0.0.0:9092,EXTERNAL://0.0.0.0:19093
advertised.listeners=INTERNAL://mykafka3:9092,EXTERNAL://localhost:9093
listener.security.protocol.map=INTERNAL:PLAINTEXT,EXTERNAL:PLAINTEXT
inter.broker.listener.name=INTERNAL
zookeeper.connect=mykafka1:2181

systemctl start kafka
