module Fortholito

  class WordDefinitionExpression
    attr_reader :tests
    alias_method :orig_push, :push

    def push expr
      if expr.token.is_word? "<EXAMPLE>"
        @tests ||= []
        @tests.push WordTest.new self.value

      elsif @tests
        @tests.last.push expr

      else
        orig_push expr
      end
    end
  end

  class WordTest
    def initialize word
      @word = word
      @code = {:given => [], :expect => []}
      @state = :given
    end
    def push expr
      return if expr.token.is_word? "given:"
      if expr.token.is_word? "expect:"
        @state = :expect
      else
        @code[@state].push expr
      end
    end
    def givens
      @code[:given]
    end
    def expectations
      @code[:expect]
    end
    def to_s
      "#{@code[:given].map{|g| g.value}.join(" ")} #{@word}"
    end
  end

  class Evaluator
    alias_method :orig_forth_define_word, :forth_define_word

    def forth_define_word definition
      name = definition.value
      orig_forth_define_word definition
      if definition.tests
        word = getword name
        word.make_safe # assuming the tests will pass
        definition.tests.each do |test|
          test.givens.each {|given| evaluate given }
          Fortholito.no_output = true
          word.call_unsafe
          Fortholito.no_output = false
          result, @stack = @stack, []
          test.expectations.each {|expect| evaluate expect }
          unless @stack == result
            word.fail
            puts "\n*** FAILURE testing #{name}"
            puts "    Given: #{test}"
            puts " expected: #{@stack.inspect}"
            puts "  but got: #{result.inspect}"
          end
          @stack = []
        end
      #else
      #  puts "WARNING: #{name} has no tests!"
      end
    end
  end

  ## Here we open up the Word class and add our own
  #  definitions of initialize, call and describe.
  #  The purpose is to keep information about how
  #  well testet a word is, and prevent it to be used
  #  if it's not tested.
  #
  class Word
    alias_method :orig_initialize, :initialize
    alias_method :orig_call, :call
    alias_method :orig_describe, :describe

    def initialize name, action, options = {}
      @verified = false
      orig_initialize name, action, options
    end
    
    def call
      raise "#{@name} has not been tested, and can't be used!" unless @verified
      orig_call
    end

    def call_unsafe
      orig_call
    end

    def describe
      orig_describe
      puts " Test extention: Verified? #{@verified}"
    end

    def make_safe
      @verified = true
    end
    def fail
      @verified = false
    end
  end

  ## Here we open up the Vocabulary and add our own
  #  code to make all currently defined words safe!
  #  
  module Vocabulary
    def make_all_current_words_safe
      @dictionary.each do |name, action|
        action.make_safe
      end
    end
  end

  ## Finally we open up the Runtime and hook into
  #  initialize to call the method that makes all
  #  words safe
  #
  class Runtime
    alias_method :orig_initialize, :initialize

    def initialize
      orig_initialize
      @evaluator.make_all_current_words_safe
    end
  end

end
