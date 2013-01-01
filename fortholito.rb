require "continuation"

module FortholitoExtensions
  def defword name, action
    @dictionary ||= {}
    @dictionary[name] = action
  end
  def execute_word word
    action = @dictionary[word]
    raise "Word '#{word}' undefined!" unless action
    action.call
  end
end

module FortholitoVocabulary
  def initialize_vocabulary
    defword '+',    Proc.new { push pop + pop }
    defword '-',    Proc.new { push pop - pop }
    defword '*',    Proc.new { push pop * pop }
    defword '/',    Proc.new { push pop / pop }
    defword 'mod',  Proc.new { push pop % pop }

    defword '=', Proc.new { push bool2flag pop == pop }
    defword '<', Proc.new { push bool2flag pop > pop  }
    defword '>', Proc.new { push bool2flag pop < pop  }

    defword 'or', Proc.new {
      a, b = pop, pop
      push bool2flag (a == Fortholito::TRUE_FLAG or b == Fortholito::TRUE_FLAG) 
    }
    defword 'and', Proc.new {
      a, b = pop, pop
      push bool2flag (a == Fortholito::TRUE_FLAG and b == Fortholito::TRUE_FLAG) 
    }

    defword 'depth',  Proc.new { push @stack.size }
    defword 'drop',   Proc.new { pop }
    defword 'dup',    Proc.new { push @stack.last }
    defword 'swap',   Proc.new {
      a, b = pop, pop
      push a
      push b
    }

    @if_stack = []
    @supressing_state = false

    defword 'if', Proc.new {
      @if_stack << pop == Fortholito::TRUE_FLAG
      @supressing_state = (@if_stack.last == false)
    }

    defword 'else', Proc.new { 
      @supressing_state = @if_stack.last
    } 
    defword 'then', Proc.new { 
      @if_stack.pop
      @supressing_state = false
    } 
  end
end

class Fortholito
  include FortholitoExtensions
  include FortholitoVocabulary

  TRUE_FLAG = -1
  FALSE_FLAG = 0

  def initialize
    @debug = false
    @stack = []
    @rules = {
      /^(?:\-){0,1}\d+\.\d+/    => Proc.new {|token| push token.to_f },
      /^(?:\-){0,1}\d+/         => Proc.new {|token| push token.to_i },
      
      /^\\ .*\n/                => Proc.new {|token| nil },
      /^\\ .*$/                 => Proc.new {|token| nil },

      /^[^ \n]+/                => Proc.new {|token| execute_word token },
      
      /^\n+/                    => Proc.new {|token| nil },
      /^ +/                     => Proc.new {|token| nil }
    }
    initialize_vocabulary
  end

  def push x ; @stack << x unless @supressing_state ; end
  def pop    ; @stack.pop unless @supressing_state  ; end

  def bool2flag b
    return TRUE_FLAG if b
    return FALSE_FLAG
  end

  def eval code
    dbg "\n->EVAL #{code.inspect}"
    code = eval_next code while code.length > 0
    dbg "->EVAL DONE\n"
    return @stack
  end

  def eval_next code, supress=false
    token_recognized = false
    @rules.each do |regex, action|
      
      dbg "--->USING RULE #{regex}"
      match = code.scan regex
      dbg "--->MATCH = " + match.inspect

      if match.size > 0
        dbg "---->CALLING #{action.inspect}"

        action.call match[0]
        code = code[match[0].length..-1]

        dbg "---->CODE = #{code.inspect}"
        token_recognized = true
        break
      end
    end
    raise "SYNTAX ERROR at #{code.inspect}" unless token_recognized
    return code
  end

  def dbg x
    puts x if @debug
  end
end
