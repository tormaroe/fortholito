module Fortholito
  class Repl
    
    def initialize runtime, options = {}
      @runtime = runtime
      @prompt = options[:prompt] || "FORTH> "
      @do_splash = true
    end

    def run_with source
      @do_splash = false
      eval source
      run
    end

    def run
      puts splash if @do_splash
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
