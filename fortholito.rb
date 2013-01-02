require "./fortholito/lexer"
require "./fortholito/parser"
require "./fortholito/evaluator"

module Fortholito
  class Runtime
    def initialize
      @evaluator = Evaluator.new
    end

    def eval source

      puts "SOURCE:"
      p source

      lexer = Lexer.new source
      lexer.tokenize
      puts "TOKENS:"
      p lexer.tokens
      
      parser = Parser.new lexer.tokens
      parser.build_ast
      puts "AST:"
      p parser.ast

      @evaluator.execute parser.ast
      puts "STACK:"
      p @evaluator.stack
    end
  end
end

f = Fortholito::Runtime.new
f.eval <<EOF
  1 2 3 +

EOF
