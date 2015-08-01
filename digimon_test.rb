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

if __FILE__ == $0
  1.upto(20) do |i|
    begin
      DigimonTest.search(i)
    rescue => err
      puts 'rescued by the last raise'
      puts err.message
    end
  end
    

end
