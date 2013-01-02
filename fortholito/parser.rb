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
      if c.type == TYPE_FLOAT or c.type == TYPE_INT or c.type == TYPE_WORD
        @ast.push PushExpression.new c
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
  end

  class PushExpression < Expression; end
end
