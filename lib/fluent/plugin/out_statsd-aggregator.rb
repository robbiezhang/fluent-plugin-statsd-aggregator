require 'fluent/output'

module Fluent

  class OutputStatsdAggregator < Output

    Plugin.register_output('statsd-aggregator', self)

    def initialize
      super
      require_relative 'statsd_lib'
    end

    config_param :flush_interval, :time, :default => 10
    config_param :threshold_percentile, :integer, :default => 90
    config_param :persist_file, :string, :default => nil
    config_param :out_tag, :string

    def configure(conf)
      super
      @statsd = OMS::StatsDState.new(@flush_interval, @threshold_percentile, @persist_file, @log)
    end

    def start
      super

      @finished = false
      @condition = ConditionVariable.new
      @mutex = Mutex.new
      @thread = Thread.new(&method(:run_periodic))
    end

    def shutdown
      super

      @mutex.synchronize {
        @finished = true
        @condition.signal
      }
      @thread.join
    end

    def emit(tag, es, chain)
      chain.next
      es.each {| time, record |
        @log.debug "Receiving data in aggregator #{time}, #{record}"
        @statsd.receive(record['message'])
      }
    end

  private

    def enumerate
      time = Time.now.to_f

      data = @statsd.aggregate()

      Fluent::Engine.emit(@out_tag, time, data)
    end

    def run_periodic
      @mutex.lock
      done = @finished
      until done
        @condition.wait(@mutex, @flush_interval)
        done = @finished
        @mutex.unlock
        if !done
          enumerate
        end
        @mutex.lock
      end
      @mutex.unlock
    end

  end # class

end # module Fluent
