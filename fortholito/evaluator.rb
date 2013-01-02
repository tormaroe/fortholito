module Fortholito
  class Evaluator
    attr_reader :stack
    def initialize
      @stack = []
      @dictionary = {}

      @dictionary["+"] = Proc.new { push pop + pop }
    end

    def push x ; @stack.push x ; end
    def pop    ; @stack.pop    ; end
    
    def call_word word
      action = @dictionary[word]
      raise "Word '#{word}' undefined!" unless action
      action.call
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
