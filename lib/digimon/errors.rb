module Digimon
  class UndefinedStrategy < StandardError
    def initialize(strategy)
      super("Undefined strategy: #{strategy.to_s}")
    end
  end

  class MissingRequiredKey < StandardError
    def initialize(key)
      super("Mising required key: #{key}")
    end
  end
end