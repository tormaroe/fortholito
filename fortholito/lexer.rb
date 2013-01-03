module Fortholito

  TYPE_STRING = :string
  TYPE_FLOAT = :float
  TYPE_INT = :int
  TYPE_WORD = :word
  TYPE_WORD_DEFINITION = :word_definition
  TYPE_WORD_DEFINITION_END = :word_definition_end
  TYPE_IF = :if
  TYPE_THEN = :then

  Token = Struct.new(:text, :type) do

  end

  class Lexer
    attr_reader :tokens
    def initialize source
      @source = source
      @tokens = []

      @tokenizers = {
        /\A\"(?:[^\"\\]*(?:\\.[^\"\\]*)*)\"/   => TYPE_STRING,
        /\A\([^\(\)]*\)/                       => :whitespace, # comment
        /\A(?:\-){0,1}\d+\.\d+(?:$|[ \n]+)/    => TYPE_FLOAT,
        /\A(?:\-){0,1}\d+(?:$|[ \n]+)/         => TYPE_INT,
        /\A\\ .*\n+/               => :whitespace, # comment
        /\A\\ .*$/                 => :whitespace, # comment
        /\A:[ \n]+/                => TYPE_WORD_DEFINITION,
        /\A;(?:$|[ \n]+)/          => TYPE_WORD_DEFINITION_END,
        /\Aif[ \n]+/               => TYPE_IF,
        /\Athen[ \n]+/               => TYPE_THEN,
        /\A[^ \n]+/                => TYPE_WORD,
        /\A\n+/                    => :whitespace,
        /\A +/                     => :whitespace
      }
    end
    def tokenize
      next_token while @source.length > 0
    end
    def next_token
      @tokenizers.each do |regex, type|
        match = @source.scan regex
        if match.size > 0
          consume_token match, type
          return
        end
      end
      fail_lexer
    end
    def consume_token match, type
      @tokens.push Token.new match[0], type unless type == :whitespace
      @source = @source[match[0].length..-1]
    end
    def fail_lexer
      raise "Unrecognized token at #{@source.inspect}"
    end
  end
end
