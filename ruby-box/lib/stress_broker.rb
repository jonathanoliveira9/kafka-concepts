require 'kafka'
require 'concurrent-ruby'

class StressBroker
  def initialize(num_messages = 500_000, num_threads = 20)
    @num_messages = num_messages
    @num_threads = num_threads
  end

  def execute
    puts "Initializing stress on Kafka #{@num_messages} messages..."
    stress_test(producer, 'strees-benchmarking')

    puts "Finished!"
  end

  private

  def producer
    @producer = kafka.async_producer(
      max_queue_size: 1_000_000,
      delivery_threshold: 100, 
      delivery_interval: 0.2,
      compression_codec: :snappy)
  end

  def stress_test(producer, topic)
    pool = Concurrent::FixedThreadPool.new(@num_threads)

    @num_messages.times do |i|
      pool.post do 
        key = "key-#{i % 1000 }"
        message = { message: Time.now.to_f }

        begin
          producer.produce(message, topic: topic, partition_key: key)
        rescue => e
          puts "Erro to producer message #{e.message}"
          
        end
      end
    end

    pool.shutdown
    pool.wait_for_termination
    producer.shutdown
  end

  def kafka
    @kafka ||= Kafka.new(["kafka1:9092", "kafka2:9093", "kafka3:9094"], client_id: "stress-tester")
  end
end
