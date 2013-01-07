module Fortholito

  class Parser
    # TODO: Extend with testing syntax
  end

  class Evaluator
    # TODO: Extend with testing semantics
  end

  class Word
    alias_method :orig_initialize, :initialize
    alias_method :orig_call, :call
    alias_method :orig_describe, :describe

    def initialize name, action, options = {}
      @verified = false
      orig_initialize name, action, options
    end
    
    def call
      # TODO: Verify that word has been properly tested before calling
      orig_call
    end

    def describe
      orig_describe
      puts " Test extention: Verified? #{@verified}"
    end
  end

  # TODO: put all existing words in safe list

end
