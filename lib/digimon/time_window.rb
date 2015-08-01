require 'digimon/strategy'
module Digimon
  class  TimeWindow < Strategy
    REQUIRED_KEYS = %i(threshold time_window)

    def initialize(params)
      params        = self.initialize_strategy(params)
      @action_queue = []
      REQUIRED_KEYS.each do |key| 
        raise MissingRequiredKey.new(key) if params[key].blank?
        @configuration[key] = params[key]
      end
    end

    def open?
      self.failed_count >= @configuration[:threshold]
    end

    def on_open
      self.enqueue(REJECTED)
      super
    end

    def on_success
      self.enqueue(SUCCEEDED)
    end

    def on_failure
      self.enqueue(FAILED)
      super
    end


    def enqueue(status)
      @action_queue << {:timestamp => Time.now, :status => status}
    end

    def failed_count
      time = Time.now
      @action_queue.select!{|action| action[:timestamp] >= time - @configuration[:time_window].second }
      @action_queue.select {|action| action[:status] == FAILED}.size
    end

    def self.succeeded_count
      time = Time.now
      @action_queue.select!{|action| action[:timestamp] >= time - @configuration[:time_window].second }
      @action_queue.select {|action| action[:status] == SUCCEEDED}.size
    end
  end
end
