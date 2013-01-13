
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

    def push x ; @stack.push x ; show_trace ; end
    def pop    ; x = @stack.pop    ; show_trace ; x ; end

    def output txt
      print txt unless Fortholito.no_output
    end

    def show_trace
      p @stack if Fortholito.stacktrace
    end
    
    def bool2flag b
      return TRUE_FLAG if b
      return FALSE_FLAG
    end
    def flag2bool f
      return TRUE_FLAG == f
    end

    def execute source
      lexer = Lexer.new source
      lexer.tokenize
      
      parser = Parser.new lexer.tokens
      parser.build_ast
      
      parser.ast.each {|expression| evaluate expression }
    end

    def evaluate expression
      if expression.class == PushExpression
        push expression.value
      
      elsif expression.class == CallWordExpression
        call_word expression.value

      elsif expression.class == WordDefinitionExpression
        forth_define_word expression
      
      elsif expression.class == IfElseExpression
        do_if_else expression

      elsif expression.class == LoopExpression
        do_loop expression

      else
        raise "Don't know how to evaluate #{expression.inspect}"
      end
    end

    def forth_define_word definition
      defword definition.value, lambda {
        definition.expressions.each {|e| evaluate e }
      }
    end

    def do_if_else expression
      truth = flag2bool pop
      expression.branch(truth).each {|e| evaluate e }
    end

    def do_loop expression
      expression.loop(
        :evaluate => Proc.new {|e| self.evaluate e},
        :pop_thruth => Proc.new {self.flag2bool(pop) }
      )
    end
  end
end
