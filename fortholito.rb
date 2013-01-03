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
  
  @showstack = false
  def self.showstack    ; @showstack     ; end
  def self.showstack= b ; @showstack = b ; end

  @stacktrace = false
  def self.stacktrace    ; @stacktrace     ; end
  def self.stacktrace= b ; @stacktrace = b ; end

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
    if ARGV.size == 0
      repl = Repl.new Runtime.new, 
        :prompt => 'ok  '
      repl.run
    else
      raise "Args not implemented yet"
    end
  end
end


