module Digimon
  class Strategy
    FAILED        = :failed
    SUCCEEDED     = :succeeded
    REJECTED      = :rejected
    OPTIONAL_KEYS = %i(exception_on_open exceptions_to_capture exceptions_on_failure default_return)

    def initialize_strategy(params)
      params = params.dup.with_indifferent_access
      @configuration = HashWithIndifferentAccess.new
      OPTIONAL_KEYS.each do |key| 
        @configuration[key] = params[key] if params[key]
      end
      params
    end

    def on_failure
      raise @configuration[:exception_on_failure] if @configuration[:exception_on_failure]
    end

    def on_open
      raise @configuration[:exception_on_open] if @configuration[:exception_on_open]
      @configuration[:default_return]
    end

    def on_success
    end


    def default_return
      @configuration[:default_return]
    end

    def captured_exceptions
      Array(@configuration[:exceptions_to_capture])
    end
    def closed?
      !self.open?
    end
  end
end
