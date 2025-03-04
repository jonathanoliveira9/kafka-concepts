require 'kafka'

class Producer
  def initialize(topic:, message:)
    @topic = topic
    @message = message
  end

  def execute
    produce
  end

  private

  def produce
    producer = kafka.producer

    producer.produce(@message, topic: @topic)
    producer.deliver_messages   # flush the message to Kafka
  end

  def kafka
    Kafka.new(["kafka1:9092", "kafka2:9093", "kafka3:9094"], client_id: "ruby-producer")
  end
end
