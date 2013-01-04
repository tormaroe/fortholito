module Fortholito

  # "Global" contants about the environment
  #
  VERSION = '0.2'
  LIBDIR = File.join File.dirname(__FILE__), "fortholito"

  # Require all parts of FORTHolito
  #
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
  # 
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
      @evaluator.execute source
      @evaluator.stack
    end

    def stack
      @evaluator.stack
    end
  end

  
  ## ------------------------------------------------- MAIN

  if __FILE__ == $PROGRAM_NAME

    repl = Repl.new Runtime.new, :prompt => 'ok  '

    if ARGV.size > 0
      file = ARGV.shift
      raise "#{file} is not a file" unless File.exist? file
      repl.source.push File.read file
    end

    repl.run
  end
end


