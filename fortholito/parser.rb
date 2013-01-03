module Fortholito
  class Parser
    attr_reader :ast
    def initialize tokens
      @tokens = tokens
      @index = 0
      @ast = []
      @parser_stack = [@ast]
    end
    def build_ast
      expression until eof
      raise "EOF not expected!" if @parser_stack.size > 1
    end

    def expression
      c = current
      
      if c.type == TYPE_FLOAT or c.type == TYPE_INT or c.type == TYPE_STRING
        push PushExpression.new c
        consume

      elsif c.type == TYPE_WORD
        push CallWordExpression.new c
        consume
      
      elsif c.type == TYPE_WORD_DEFINITION
        consume # :
        raise "':' must be followed by a word (was #{current.inspect})" unless current.type == TYPE_WORD
        definition = WordDefinitionExpression.new current
        @parser_stack.push definition
        consume # word

      elsif c.type == TYPE_WORD_DEFINITION_END
        definition = @parser_stack.pop
        raise "';' must follow a word definition" unless definition.class == WordDefinitionExpression
        push definition
        consume

      elsif c.type == TYPE_IF
        @parser_stack.push IfElseExpression.new c
        consume

      elsif c.type == TYPE_THEN
        push @parser_stack.pop
        consume
      
      else
        raise "Don't know how to parse #{c.inspect}"
      end
    end

    def push expr
      @parser_stack.last.push expr
    end

    def current
      raise "Unexpected end of program" unless @tokens.size > @index
      @tokens[@index]
    end
    def consume
      @index += 1
    end
    def eof
      @tokens.size == @index
    end
  end

  class Expression
    attr_reader :token
    def initialize token
      @token = token
    end
    def value
      @token.text
    end
  end

  class PushExpression < Expression 
    def value
      if @token.type == TYPE_INT
        @token.text.to_i
      elsif @token.type == TYPE_FLOAT
        @token.text.to_f
      elsif @token.type == TYPE_STRING
        @token.text[1..-2]
      else
        super
      end
    end
  end

  class CallWordExpression < Expression; end
  
  class WordDefinitionExpression < Expression
    attr_reader :expressions
    def initialize word
      super word
      @expressions = []
    end
    def push expr
      @expressions.push expr
    end
  end

  class IfElseExpression < Expression
    attr_reader :when_true, :when_false
    def initialize token
      super token
      @state = true
      @when_true, @when_false = [], []
    end
    def push expr
      if expr.token.text == "else"
        @state = false
        return
      end
      if @state
        @when_true.push expr
      else
        @when_false.push expr
      end
    end
  end
end
