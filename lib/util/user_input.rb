# encoding: utf-8

module UserInput
  # Prints `msg` and reads user input
  def self.get msg
    STDOUT.print("#{msg} ")
    STDOUT.flush
    STDIN.gets.chomp
  end
end
