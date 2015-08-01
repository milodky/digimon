# Digimon
 A simple circuit breaker implemented in Ruby

## Installation

Add this line to your application's Gemfile:

    gem 'digimon'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install digimon

## Usage

require 'digimon'
class DigimonTest
  extend Digimon
  breaker :search, :threshold => 5, :time_window => 300, :strategy => 'time_window', :exception_on_open => RuntimeError.new('return on open'), :exceptions_to_capture => RuntimeError
  def self.search(i)
    puts
    raise 'fake error' if rand > 0.5
    puts i
  end
end
  

## Contributing

1. Fork it ( https://github.com/milodky/digimon/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
