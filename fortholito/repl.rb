module Fortholito
  class Repl
    attr_reader :source

    def initialize runtime, options = {}
      @runtime = runtime
      @prompt = options[:prompt] || "FORTH> "
      @do_splash = true
      @source = []
    end
    
    def run
      @do_splash = @source.size == 0
      eval @source.shift until @source.size == 0
      puts splash if @do_splash
      repl
    end

    def repl
      loop { eval read ; print }
    end

    def splash
      "Welcome to FORTHolito version #{VERSION} by @tormaroe\n" +
        "Type 'help' and hit [ENTER] to get started.."
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
