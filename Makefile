# Makefile for Kafka operations

# Variable for topic name, default is test-topic
topic_name ?= test-topic

# Variable for partition count, default is 1
partitions ?= 1

# Create a Kafka topic
create-topic:
	@echo "Creating topic: $(topic_name)"
	docker exec -it kafka1 kafka-topics --create --topic $(topic_name) --bootstrap-server kafka1:9092 --partitions 1 --replication-factor 1

# List Kafka topics
list-topics:
	@echo "Listing topics..."
	docker exec -it kafka kafka-topics --list --bootstrap-server kafka:9092

# Alter Kafka topic partitions
alter-topic-partitions:
	@echo "Altering topic $(topic_name) to $(partitions) partitions..."
	docker exec -it kafka1 kafka-topics --alter --topic $(topic_name) --bootstrap-server kafka1:9092 --partitions $(partitions)

# Produce messages to a Kafka topic (interactive)
produce-topic:
	@echo "Starting producer for topic: $(topic_name)..."
	docker exec -it kafka kafka-console-producer --broker-list kafka:9092 --topic $(topic_name)

# Consume messages from a Kafka topic from the beginning (interactive)
consume-topic:
	@echo "Starting consumer for topic: $(topic_name) from beginning..."
	docker exec -it kafka kafka-console-consumer --bootstrap-server kafka:9092 --topic $(topic_name) --from-beginning

.PHONY: create-topic list-topics alter-topic-partitions produce-topic consume-topic
