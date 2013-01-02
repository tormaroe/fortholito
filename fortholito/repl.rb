module Fortholito
  class Repl
    
    def initialize
      @runtime = Runtime.new
      loop { eval read ; print }
    end

    def read
      Kernel.print "$ "
      gets.chomp
    end

    def eval input
      @runtime.eval input
    end

    def print
      p @runtime.stack
    end

    def loop 
      while true
        begin
          yield
        rescue Exception => e
          exit 0 if e.class == ::SystemExit
          puts "#{e.inspect}"
        end
      end
    end

  end
end
