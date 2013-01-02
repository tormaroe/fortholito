require "./fortholito/lexer"
require "./fortholito/parser"

module Fortholito
  class Runtime
    def eval source
      lexer = Lexer.new source
      lexer.tokenize
      #puts lexer.tokens
      
      parser = Parser.new lexer.tokens
      parser.build_ast
      puts parser.ast
    end
  end
end

f = Fortholito::Runtime.new
f.eval <<EOF
  -2 3.01 + word

EOF
