require "./fortholito/lexer"

module Fortholito
  class Runtime
    def eval source
      lexer = Lexer.new source
      lexer.tokenize
      puts lexer.tokens
    end
  end
end

f = Fortholito::Runtime.new
f.eval <<EOF
  -2 3.01 + word

EOF
