require 'kafka'
require 'concurrent-ruby'
require 'benchmark'

class StressBroker
  def initialize(num_messages = 1_000, num_threads = 20)
    @num_messages = num_messages
    @num_threads = num_threads
  end

  def execute_benchmark
    Benchmark.bmbm do |x|
      x.report("protobuf") { stress_protobuf }
      x.report("json") { stress_json }
    end
  end

  def execute
    stress_json
  end

  private

  def topic
    'test-topic01-protobuf'
  end

  def message
    @message ||= Array.new(10 * 1024) { rand(65..90).chr }.join
  end

  def stress_json
    message_json = { id: 1, name: message }

    stress_test(message_json)
  end

  def stress_protobuf
    message_protobuf = Example::User.new(id: 1, name: message)

    encoded = Example::User.encode(message_protobuf)

    stress_test(encoded)
  end

  def stress_test(message)
    pool = Concurrent::FixedThreadPool.new(@num_threads)

    @num_messages.times do |i|
      pool.post do 
        key = "key-#{i % 1000 }"
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

  def producer
    @producer = kafka.async_producer(
      max_queue_size: 1_000_000,
      delivery_threshold: 100, 
      delivery_interval: 0.2,
      compression_codec: :snappy
    )
  end

  def kafka
    @kafka ||= Kafka.new(
      ["kafka1:9092", "kafka2:9093", "kafka3:9094"],
      client_id: "stress-tester"
      # required_acks: 0, At most once
      # required_acks: 1 at least once
      # required_acks: "all" exactly once
    )
  end
end
