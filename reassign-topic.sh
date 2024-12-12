kafka-topics --bootstrap-server localhost:9092 --describe --topic platform.scooter.user.change
kafka-reassign-partitions --bootstrap-server localhost:9092 --generate --topics-to-move-json-file ~/Documents/kafka/topics-to-move.json --broker-list "1,2,3"

Current partition replica assignment
{"version":1,"partitions":[{"topic":"platform.scooter.user.change","partition":0,"replicas":[3],"log_dirs":["any"]},{"topic":"platform.scooter.user.change","partition":1,"replicas":[1],"log_dirs":["any"]},{"topic":"platform.scooter.user.change","partition":2,"replicas":[2],"log_dirs":["any"]}]}

Proposed partition reassignment configuration
{"version":1,"partitions":[{"topic":"platform.scooter.user.change","partition":0,"replicas":[1],"log_dirs":["any"]},{"topic":"platform.scooter.user.change","partition":1,"replicas":[2],"log_dirs":["any"]},{"topic":"platform.scooter.user.change","partition":2,"replicas":[3],"log_dirs":["any"]}]}

kafka-reassign-partitions --bootstrap-server localhost:9092 --reassignment-json-file ~/Documents/kafka/reassignment.json --execute

Save this to use as the --reassignment-json-file option during rollback
Successfully started partition reassignments for platform.scooter.user.change-0,platform.scooter.user.change-1,platform.scooter.user.change-2

kafka-reassign-partitions --bootstrap-server localhost:9092 --reassignment-json-file ~/Documents/kafka/reassignment.json --verify
Status of partition reassignment:
Reassignment of partition platform.scooter.user.change-0 is completed.
Reassignment of partition platform.scooter.user.change-1 is completed.
Reassignment of partition platform.scooter.user.change-2 is completed.

Clearing broker-level throttles on brokers 1,2,3
Clearing topic-level throttles on topic platform.scooter.user.change

kafka-topics --bootstrap-server localhost:9092 --describe --topic platform.scooter.user.change
Topic: platform.scooter.user.change	TopicId: vrQ9hID3Tf25PvxK_08Xsg	PartitionCount: 3	ReplicationFactor: 3	Configs: segment.bytes=1073741824
	Topic: platform.scooter.user.change	Partition: 0	Leader: 3	Replicas: 1,2,3	Isr: 3,2,1	Elr: N/A	LastKnownElr: N/A
	Topic: platform.scooter.user.change	Partition: 1	Leader: 1	Replicas: 2,3,1	Isr: 1,2,3	Elr: N/A	LastKnownElr: N/A
	Topic: platform.scooter.user.change	Partition: 2	Leader: 2	Replicas: 3,1,2	Isr: 2,1,3	Elr: N/A	LastKnownElr: N/A
	
kafka-configs --bootstrap-server localhost:9092 --entity-type topics --entity-name platform.scooter.user.change --describe
Dynamic configs for topic platform.scooter.user.change are:

kafka-configs --bootstrap-server localhost:9092 --entity-type topics --entity-name platform.scooter.user.change --alter --add-config min.insync.replicas=2

# Dynamic config store in zk, persistent when broker restart
kafka-configs --bootstrap-server localhost:9091 --entity-type topics --entity-name platform.scooter.user.change --describe
kafka-configs --bootstrap-server localhost:9092 --entity-type topics --entity-name platform.scooter.user.change --describe
kafka-configs --bootstrap-server localhost:9093 --entity-type topics --entity-name platform.scooter.user.change --describe
Dynamic configs for topic platform.scooter.user.change are:
  min.insync.replicas=2 sensitive=false synonyms={DYNAMIC_TOPIC_CONFIG:min.insync.replicas=2, DEFAULT_CONFIG:min.insync.replicas=1}
