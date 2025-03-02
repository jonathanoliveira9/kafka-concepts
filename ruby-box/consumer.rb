require 'kafka'

class Consumer
  def initialize(topic)
    @topic = topic
  end

  def execute
    puts "Listening for messages..."
    consumer = kafka.consumer(group_id: "my-consumer")
    consumer.subscribe(@topic)
    consumer.each_message do |message|
      puts message
    end
  end

  private

  def kafka
    Kafka.new(["kafka1:9092", "kafka2:9093", "kafka3:9094"], client_id: "ruby-consumer")
  end
end
