module Fortholito
  class Parser
    attr_reader :ast
    def initialize tokens
      @tokens = tokens
      @index = 0
      @ast = []
    end
    def build_ast
      expression until eof
    end

    def expression
      c = current
      if c.type == TYPE_FLOAT or c.type == TYPE_INT
        @ast.push PushExpression.new c
        consume
      elsif c.type == TYPE_WORD
        @ast.push CallWordExpression.new c
        consume
      end
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
      else
        super
      end
    end
  end
  class CallWordExpression < Expression; end
end
