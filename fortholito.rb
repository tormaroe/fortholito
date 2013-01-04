module Fortholito

  VERSION = '0.2'
  
  LIBDIR = File.join File.dirname(__FILE__), "fortholito"

  def self.load_dependencies deps
    deps.each {|d| require File.join(LIBDIR, d) }
  end

  load_dependencies %w(lexer 
                       parser 
                       vocabulary 
                       evaluator 
                       repl)

  # "Global" Fortholito-variables used to
  # configure the environment at runtime
  class << self
    attr_accessor :showstack, 
                  :stacktrace
  end

  class Runtime
    def initialize
      @evaluator = Evaluator.new

      core = File.read(File.join(LIBDIR, "core.fs"))
      eval core
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

    repl = Repl.new Runtime.new, 
      :prompt => 'ok  '

    if ARGV.size == 0  
      repl.run
    else
      file = ARGV.shift
      raise "#{file} is not a file" unless File.exist? file
      repl.run_with File.read file
    end
  end
end


