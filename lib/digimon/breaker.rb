module Digimon
  METHOD_STRATEGIES = {}
  def breaker(method, params)
    params = params.dup.with_indifferent_access
    method = method.to_sym
    METHOD_STRATEGIES[method] ||= self.initialize_strategy(params)
    self._add_singleton_method(method) if self.respond_to?(method.to_sym)
  end

  def _add_singleton_method(method)
    singleton_class.send(:alias_method, *["breaker_#{method}".to_sym, method])
    define_singleton_method(method) do |*args|
      strategy = METHOD_STRATEGIES[method]
      if strategy.open?
        return strategy.on_open
      end
      ret   = strategy.default_return
      begin
        ret = self.send("breaker_#{method}".to_sym, *args)
        strategy.on_success
      rescue *strategy.captured_exceptions => err
        $stderr.puts err.message
        $stderr.puts err.backtrace
        strategy.on_failure
      rescue => err
        $stderr.puts err.message
        $stderr.puts err.backtrace
        strategy.on_failure
        raise err
      end
      ret
    end
  end

  def singleton_method_added(method)
    return if @process
    @process = true
    self._add_singleton_method(method)
    @process = false
  end


  def initialize_strategy(params)
    case params[:strategy]
      when 'time_window'
        TimeWindow.new(params)
      else
        raise UndefinedStrategy.new(params[:strategy])
    end
  end
end
