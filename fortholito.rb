
class Fortholito

  TRUE_FLAG = -1
  FALSE_FLAG = 0
  
  def initialize
    @debug = false
    @stack = []
    @rules = {
      /^(?:\-){0,1}\d+\.\d+/   => Proc.new {|token| push token.to_f },
      /^(?:\-){0,1}\d+/        => Proc.new {|token| push token.to_i },
      
      /^\+/       => Proc.new {|token| push pop + pop },
      /^-/        => Proc.new {|token| push pop - pop },
      /^\*/       => Proc.new {|token| push pop * pop },
      /^\//       => Proc.new {|token| push pop / pop },
      /^mod/        => Proc.new {|token| push pop % pop },

      /^=/        => Proc.new {|token| push bool2flag pop == pop },
      /^</        => Proc.new {|token| push bool2flag pop > pop },
      /^>/        => Proc.new {|token| push bool2flag pop < pop },
      
      /^or/       => Proc.new {|token| 
                                a, b = pop, pop
                                push bool2flag (a == TRUE_FLAG or b == TRUE_FLAG) 
                              },
      /^and/      => Proc.new {|token| 
                                a, b = pop, pop
                                push bool2flag (a == TRUE_FLAG and b == TRUE_FLAG) 
                              },

      /^depth/    => Proc.new {|token| push @stack.size },
      /^drop/     => Proc.new {|token| pop },
      /^dup/      => Proc.new {|token| push @stack.last },
      /^swap/     => Proc.new {|token| 
                                a, b = pop, pop
                                push a  ; push b
                              },

      /^(if (.+) else (.+) then)/         => Proc.new {|token| :if },

      /^\\ .*\n/    => Proc.new {|token| nil },
      /^\\ .*$/     => Proc.new {|token| nil },
      /^\n+/        => Proc.new {|token| nil },
      /^ +/       => Proc.new {|token| nil }
    }
  end

  def push x ; @stack << x ; end
  def pop    ; @stack.pop  ; end

  def bool2flag b
    return TRUE_FLAG if b
    return FALSE_FLAG
  end

  def eval code
    dbg "\n->EVAL #{code.inspect}"
    while code.length > 0
      token_recognized = false
      @rules.each do |regex, action|
        
        dbg "--->USING RULE #{regex}"
        match = code.scan regex
        dbg "--->MATCH = " + match.inspect

        if match.size > 0
          dbg "---->CALLING #{action.inspect}"
          result = action.call match[0]

          if result.class == ::Symbol
            code = send result, match, code
          else
            code = code[match[0].length..-1]
          end

          dbg "---->CODE = #{code.inspect}"
          token_recognized = true
          break
        end
      end
      raise "SYNTAX ERROR at #{code.inspect}" unless token_recognized
    end
    dbg "->EVAL DONE\n"
    return @stack
  end

  def dbg x
    puts x if @debug
  end

  def if match, code
    puts "::IF:: #{match.inspect}"
    if pop == TRUE_FLAG
      self.eval match[0][1]
    else
      self.eval match[0][2]
    end
    code[match[0][0].length..-1]
  end

end
