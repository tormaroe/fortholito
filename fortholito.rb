require "./fortholito/lexer"
require "./fortholito/parser"
require "./fortholito/vocabulary"
require "./fortholito/evaluator"

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
  end
end

