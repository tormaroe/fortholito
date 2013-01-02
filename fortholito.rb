module Fortholito

  VERSION = '0.2'

  def self.load_dependencies deps
    dir = File.join File.dirname(__FILE__), "fortholito"
    deps.each {|d| require File.join(dir, d) }
  end

  load_dependencies %w(lexer 
                       parser 
                       vocabulary 
                       evaluator 
                       repl)
  
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

  
  ## ------------------------------------------------- MAIN

  if __FILE__ == $PROGRAM_NAME
    if ARGV.size == 0
      repl = Repl.new Runtime.new, 
        :prompt => '~> '
      repl.run
    else
      raise "Args not implemented yet"
    end
  end
end


