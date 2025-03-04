require 'kafka'
class Consumer
  def initialize(topic:)
    @topic = topic
  end

  def execute
    puts "Listening for messages..."
    consumer = kafka.consumer(group_id: "my-consumer")
    consumer.subscribe(@topic)
    consumer.each_message do |message|
      puts JSON.parse(message.value)
    rescue => e
      puts "Message failed to process, sending to DLQ: #{e.message}"
      producer = kafka.producer
      producer.produce(message.value, topic: dlq_topic)
      producer.deliver_messages
    end
  end

  private

  def kafka
    Kafka.new(["kafka1:9092", "kafka2:9093", "kafka3:9094"], client_id: "ruby-consumer")
  end

  def dlq_topic
    "#{@topic}_dlq"
  end
end
