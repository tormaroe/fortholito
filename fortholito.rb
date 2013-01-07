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

    # Eval option
    eval_index = ARGV.index "--eval"
    if eval_index
      code_to_eval = ARGV[(eval_index+1)..-1].join " "
      ARGV = ARGV[0...eval_index]
    end

    # Help option
    if ARGV.include?("--help")
      puts <<EOF
Usage:

  FORTHolito [options] [files]

Options:
  --eval <code>         Evaluate code. Everything after --eval
                        is considered FORTHolito code. Code is
                        evaluated after files.
  --extend <extension>  Load an extension by name. Extensions
                        are loaded before files.
  --help                Display this help and exit.

EOF
      exit
    end

    # Load extentions
    while true
      extentions = []
      extention_index = ARGV.index("--extend")
      break unless extention_index
      extentions.push File.join "extensions", ARGV[extention_index + 1]
      ARGV.delete_at extention_index
      ARGV.delete_at extention_index
      puts "Loading extentions: #{extentions.inspect}"
      load_dependencies extentions
    end

    repl = Repl.new Runtime.new, :prompt => 'ok  '

    # Load file arguments
    while true
      if ARGV.size > 0
        file = ARGV.shift
        raise "#{file} is not a file" unless File.exist? file
        puts "Loading file: #{file}"
        repl.source.push File.read file
      else
        break
      end
    end

    if code_to_eval
      puts "Evaluation code: #{ code_to_eval }"
      repl.source.push code_to_eval
    end

    puts 
    repl.run
  end
end


