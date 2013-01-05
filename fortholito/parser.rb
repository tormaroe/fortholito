module Fortholito
  
  RESERVED_WORDS = %w(if then : ; begin until)

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
      
      if should_just_be_pushed c
        push PushExpression.new c
      
      elsif c.is_word? ":"
        consume # :
        raise "':' must be followed by a word (was #{current.inspect})" unless current.type == TYPE_WORD
        definition = WordDefinitionExpression.new current
        @parser_stack.push definition

      elsif c.is_word? ";"
        definition = @parser_stack.pop
        raise "';' must follow a word definition" unless definition.class == WordDefinitionExpression
        push definition

      elsif c.is_word? "if"
        @parser_stack.push IfElseExpression.new c

      elsif c.is_word? "then"
        push @parser_stack.pop

      elsif c.is_word? "begin"
        iterator = LoopExpression.new c
        @parser_stack.push iterator
        
      elsif c.is_word? "until"
        push c # just the word?!
        push @parser_stack.pop
      
      elsif c.type == TYPE_WORD
        push CallWordExpression.new c

      else
        raise "Don't know how to parse #{c.inspect}"
      end

      consume
    end

    def should_just_be_pushed token
      token.type == TYPE_FLOAT or
      token.type == TYPE_INT or
      (token.type == TYPE_STRING and not_reserved? token)
    end
   
    def not_reserved? token
      not RESERVED_WORDS.include? token.text.chomp.strip
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

  ## ------------------------------------------ EXPRESSION CLASSES

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
      case @token.type
      when TYPE_INT then @token.text.to_i
      when TYPE_FLOAT then @token.text.to_f
      when TYPE_STRING then eval @token.text
      else super
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
      if expr.token.is_word? "else"
        @state = false
      else
        branch(@state).push expr
      end
    end
    def branch bool
      return @when_true if bool
      return @when_false
    end
  end

  class LoopExpression < Expression
    attr_reader :code
    def initialize token
      super token
      @code = []
    end
    def push expr
      @code.push expr
    end
    def loop args
      begin
        @code.each do |expr|
          if expr.class == Token

          else
            args[:evaluate].call expr
          end
        end
      end until args[:pop_thruth].call
    end
  end
end
