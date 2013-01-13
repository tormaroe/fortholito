module Fortholito

  class Word
    def initialize name, action, options = {}
      @doc = options[:doc] || "No documentation"
      @name, @action = name, action
    end
    def call
      @action.call
    end
    def describe
      puts " #{@name} : #{@doc}"
    end
  end

  module Vocabulary
    def defword name, action, options = {}
      @dictionary ||= {}
      name = name.to_s if name.class == ::Symbol
      puts "Warning: Existing definition of '#{name}' changed" if @dictionary[name]
      @dictionary[name] = Word.new name, action, options
    end 

    def getword word
      @dictionary[(if word.class == ::Symbol then word.to_s else word end)]
    end

    def call_word word
      action = getword word
      raise "Word '#{word}' undefined!" unless action
      action.call
    end

    def initialize_vocabulary

      defword :+,    lambda { push pop + pop }
      defword :-,    lambda { push pop - pop }
      defword :*,    lambda { push pop * pop }
      defword :/,    lambda { push pop / pop }
      defword :mod,  lambda { push pop % pop }

      defword '=', lambda { push bool2flag pop == pop }
      defword :<, lambda { push bool2flag pop > pop  }
      defword :>, lambda { push bool2flag pop < pop  }

      defword :or, lambda {
        a, b = pop, pop
        push bool2flag (a == Fortholito::TRUE_FLAG or b == Fortholito::TRUE_FLAG) 
      }
      defword :and, lambda {
        a, b = pop, pop
        push bool2flag (a == Fortholito::TRUE_FLAG and b == Fortholito::TRUE_FLAG) 
      }

      defword :depth,  lambda { push @stack.size }
      defword :clear,  lambda { @stack = [] }
      defword :drop,   lambda { pop }
      defword :dup,    lambda { push @stack.last }
      defword :swap,   lambda {
        b, a = pop, pop
        push b
        push a
      }
      defword :over,   lambda {
        b, a = pop, pop
        push a
        push b
        push a
      }, :doc => "( a b -- a b a )"

      defword :rot,   lambda {
        c, b, a = pop, pop, pop
        push b
        push c
        push a
      }, :doc => "( a b c -- b c a )"

      defword '.',     lambda { output pop }, :doc => "( x --  ) Pop and print top value"
      defword :cr,    lambda { output "\n" },      :doc => "Prints a newline"
      defword :space, lambda { output " " }, :doc => "Prints a space character"

      defword :rand, lambda { push rand pop }, :doc => "( n1 -- n2 )"
      
      defword '.s'       , lambda { output "#{@stack.inspect}\n" }, :doc => "Display stack once"
      
      defword :showstack, 
        lambda { Fortholito.showstack = not(Fortholito.showstack) },
        :doc => "Use to toggle stack display on and off. Stack is displayed after each operation."

      defword :stacktrace, 
        lambda { Fortholito.stacktrace = not(Fortholito.stacktrace) },
        :doc => "Use to toggle verbose stack display on and off. Stack is displayed each time it is modified. This is usually more information than you need :)"

      defword :words, lambda {
        @dictionary.keys.sort.each_slice(4) do |w|
          puts " " + w.map{|w| w.ljust 18}.join(" ")
        end
      }, :doc => "List all words in the vocabulary"

      defword :describe, lambda {
        name = pop
        if name
          word = @dictionary[name] 
          if word
            puts word.describe
          else
            puts "Vocabulary contains no word named #{name}"
          end
        else
          puts "No name on stack to describe"
        end
      }

      defword :help, lambda {
        [ " SOME USEFULL WORDS YOU SHOULD TRY:",
          "  words       \\ display all words in the vocabulary",
          "  describe    \\ pop word (string) and show details",
          "  .           \\ pop and print the top item from the stack",
          "  .s          \\ display stack once",
          "  showstack   \\ toggle display of stack between commands",
          "  stacktrace  \\ display all modifications to stack for debugging",
          "  help:stack  \\ cheat sheet of stack overations",
          "  bye         \\ exit REPL" ].
          each {|line| puts line }
      }
      
      defword 'help:stack', lambda {
        [ " ",
          " REMOVERS:  drop    ( a   --   )  \\  also: 2drop",
          "            nip     ( a b -- b )",
          " ",
          " ADDERS:    dup     ( a   -- a a )",
          "            2dup    ( a b -- a b a b )",
          "            tuck    ( a b -- b a b )",
          "            over    ( a b -- a b a )",
          " ",
          " ROTATORS:  swap    ( a b -- b a )",
          "            rot     ( a b c -- b c a )",
          "            -rot    ( a b c -- c a b )",
          "  " ].
          each {|line| puts line }
      }

      defword :bye, lambda { exit 0 }, :doc => "Quit REPL"
    end

  end
end
