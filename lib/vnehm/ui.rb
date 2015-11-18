require 'vnehm/menu'

module Vnehm
  module UI

    ##
    # This constant used to set delay between user operation
    # Because it's more comfortable to have a small delay
    # between interactions

    SLEEP_PERIOD = 0.7

    def self.ask(arg = nil)
      say arg if arg
      $stdin.gets.chomp
    end

    def self.error(msg)
      puts "#{msg}\n".red
    end

    def self.menu(&block)
      Menu.new(&block)
    end

    def self.newline
      puts
    end

    def self.say(msg)
      puts msg
    end

    def self.sleep
      Kernel.sleep(SLEEP_PERIOD)
    end

    def self.success(msg)
      puts msg.green
    end

    def self.term(msg = nil)
      puts msg.red if msg
      raise VnehmExit
    end

    def self.warning(msg)
      puts "#{msg}".yellow
    end

  end
end
