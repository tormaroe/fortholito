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
  end

  class Evaluator
    # TODO: Extend with testing semantics
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

    def describe
      orig_describe
      puts " Test extention: Verified? #{@verified}"
    end

    def make_safe
      @verified = true
    end
  end

  ## Here we open up the Vocabulary, hook into the
  #  initialize_vocabulary method, and add our own
  #  code to make all currently defined words safe!
  #  
  module Vocabulary
    alias_method :orig_initialize_vocabulary, :initialize_vocabulary

    def initialize_vocabulary
      orig_initialize_vocabulary
      make_all_current_words_safe
    end

    def make_all_current_words_safe
      @dictionary.each do |name, action|
        action.make_safe
      end
    end
  end

end
