module Fortholito
  class Repl
    
    def initialize runtime, options = {}
      @runtime = runtime
      @prompt = options[:prompt] || "FORTH> "
      splash
      loop { eval read ; print }
    end

    def splash
      puts "Welcome to FORTHolito version #{VERSION} by @tormaroe"
    end

    def read
      Kernel.print @prompt
      gets.chomp
    end

    def eval input
      @runtime.eval input
    end

    def print
      p @runtime.stack if Fortholito.showstack
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
