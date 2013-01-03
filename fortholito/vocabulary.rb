module Fortholito
  module Vocabulary
    def defword name, action
      @dictionary ||= {}
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
      defword 'drop',   lambda { pop }
      defword 'dup',    lambda { push @stack.last }
      defword 'swap',   lambda {
        a, b = pop, pop
        push a
        push b
      }

      defword 'bye',    lambda { exit 0 }

    end

  end
end
