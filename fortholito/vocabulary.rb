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

      defword '+',    Proc.new { push pop + pop }
      defword '-',    Proc.new { push pop - pop }
      defword '*',    Proc.new { push pop * pop }
      defword '/',    Proc.new { push pop / pop }
      defword 'mod',  Proc.new { push pop % pop }

      defword '=', Proc.new { push bool2flag pop == pop }
      defword '<', Proc.new { push bool2flag pop > pop  }
      defword '>', Proc.new { push bool2flag pop < pop  }

      defword 'or', Proc.new {
        a, b = pop, pop
        push bool2flag (a == Fortholito::TRUE_FLAG or b == Fortholito::TRUE_FLAG) 
      }
      defword 'and', Proc.new {
        a, b = pop, pop
        push bool2flag (a == Fortholito::TRUE_FLAG and b == Fortholito::TRUE_FLAG) 
      }

      defword 'depth',  Proc.new { push @stack.size }
      defword 'drop',   Proc.new { pop }
      defword 'dup',    Proc.new { push @stack.last }
      defword 'swap',   Proc.new {
        a, b = pop, pop
        push a
        push b
      }

    end
  end
end
