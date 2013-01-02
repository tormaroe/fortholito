module Fortholito
  TRUE_FLAG = -1
  FALSE_FLAG = 0

  class Evaluator
    include Vocabulary
    attr_reader :stack
    def initialize
      @stack = []
      initialize_vocabulary
    end

    def push x ; @stack.push x ; end
    def pop    ; @stack.pop    ; end
    
    def bool2flag b
      return TRUE_FLAG if b
      return FALSE_FLAG
    end

    def execute ast
      ast.each do |expression|
        if expression.class == PushExpression
          push expression.value
        elsif expression.class == CallWordExpression
          call_word expression.value
        end
      end
    end
  end
end
