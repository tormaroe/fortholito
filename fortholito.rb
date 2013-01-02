require "./fortholito/lexer"
require "./fortholito/parser"
require "./fortholito/vocabulary"
require "./fortholito/evaluator"
require "./Fortholito/repl"

module Fortholito
  class Runtime
    def initialize
      @evaluator = Evaluator.new
    end

    def eval source
      lexer = Lexer.new source
      lexer.tokenize
      
      parser = Parser.new lexer.tokens
      parser.build_ast

      @evaluator.execute parser.ast
      @evaluator.stack
    end

    def stack
      @evaluator.stack
    end
  end
end


if __FILE__ == $PROGRAM_NAME
  if ARGV.size == 0
    puts "FORTHolito REPL"
    Fortholito::Repl.new.run
  else
    raise "Args not implemented yet"
  end
end
