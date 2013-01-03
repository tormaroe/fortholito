module Fortholito
  module Vocabulary
    def defword name, action
      @dictionary ||= {}
      puts "Warning: Existing definition of '#{name}' changed" if @dictionary[name]
      @dictionary[name] = action
    end 

    def call_word word
      action = @dictionary[word]
      raise "Word '#{word}' undefined!" unless action
      action.call
    end

    def initialize_vocabulary

      defword '+',    lambda { push pop + pop }
      defword '-',    lambda { push pop - pop }
      defword '*',    lambda { push pop * pop }
      defword '/',    lambda { push pop / pop }
      defword 'mod',  lambda { push pop % pop }

      defword '=', lambda { push bool2flag pop == pop }
      defword '<', lambda { push bool2flag pop > pop  }
      defword '>', lambda { push bool2flag pop < pop  }

      defword 'or', lambda {
        a, b = pop, pop
        push bool2flag (a == Fortholito::TRUE_FLAG or b == Fortholito::TRUE_FLAG) 
      }
      defword 'and', lambda {
        a, b = pop, pop
        push bool2flag (a == Fortholito::TRUE_FLAG and b == Fortholito::TRUE_FLAG) 
      }

      defword 'depth',  lambda { push @stack.size }
      defword 'clear',  lambda { @stack = [] }
      defword 'drop',   lambda { pop }
      defword 'dup',    lambda { push @stack.last }
      defword 'swap',   lambda {
        b, a = pop, pop
        push b
        push a
      }
      defword 'over',   lambda {
        b, a = pop, pop
        push a
        push b
        push a
      }
      defword 'rot',   lambda {
        c, b, a = pop, pop, pop
        push b
        push c
        push a
      }

      defword '.',      lambda { print pop }
      defword 'cr',      lambda { puts }
      defword 'space',      lambda { print " " }

      defword '.s'       , lambda { p @stack }
      defword 'showstack', lambda { Fortholito.showstack = not(Fortholito.showstack) }
      defword 'stacktrace', lambda { Fortholito.stacktrace = not(Fortholito.stacktrace) }

      defword 'help', lambda {
        [ " SOME USEFULL WORDS YOU SHOULD TRY:",
          "  .           \\ pop and print the top item from the stack",
          "  .s          \\ display stack once",
          "  showstack   \\ toggle display of stack between commands",
          "  stacktrace  \\ display all modifications to stack for debugging",
          "  bye         \\ exit REPL" ].
          each {|line| puts line }
      }

      defword 'bye',    lambda { exit 0 }

    end

  end
end
