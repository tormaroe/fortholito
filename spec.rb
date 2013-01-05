require "./spec_framework"

class FortholitoSpecification
  extend Specification
  
  spec :canary_test, :code => '      ', :expect => [] 

  ## ------------------------------------------ TYPES
  
  spec :push_a_number, :expect => [1], :code => <<EOF
    1
EOF

  spec :push_several_numbers, :code => %(
    1 -1 0.6
  ), :expect => [1, -1, 0.6]

  spec :comment, :expect => [1, 2], :code => <<EOF
    1 \\ pushing 1
    2 \\ pushing 2
EOF

  spec :single_line_with_comment, :expect => [1], :code => '1 \\ comment 1 dup'

  ## ------------------------------------------ STACK OPERATIONS

  spec :drop, :expect => [1, 2], :code => <<EOF
    1 2 3 4 drop drop
EOF

  spec :dup, :code => %(
    2 dup
  ), :expect => [2, 2]

  spec :swap, :code => %(
    1 2 3 swap
  ), :expect => [1, 3, 2]

  spec :depth, :code => %(
    1 2 3 depth
  ), :expect => [1, 2, 3, 3]

  spec :clear, :code => %(
    1 2 3 clear
  ), :expect => []

  spec :over, :code => %(
    1 2 over
  ), :expect => [1, 2, 1]

  spec :rot, :code => %(
    1 2 3 rot
  ), :expect => [2, 3, 1]

  ## ------------------------------------------ BOOLEAN LOGIC

  spec :or, :code => %(
    -1 -1 or
    -1  0 or
     0 -1 or  
     0  0 or
  ), :expect => [
    Fortholito::TRUE_FLAG, 
    Fortholito::TRUE_FLAG, 
    Fortholito::TRUE_FLAG, 
    Fortholito::FALSE_FLAG]

  spec :and, :code => %(
    -1 -1 and
    -1  0 and
     0 -1 and 
     0  0 and
  ), :expect => [
    Fortholito::TRUE_FLAG, 
    Fortholito::FALSE_FLAG, 
    Fortholito::FALSE_FLAG, 
    Fortholito::FALSE_FLAG]

  ## ------------------------------------------ COMPARE

  spec :equal, :code => %(
    2 2 =   2 1 =
  ), :expect => [Fortholito::TRUE_FLAG, Fortholito::FALSE_FLAG]

  spec :less_than, :code => %(
    1 2 <   2 1 <
  ), :expect => [Fortholito::TRUE_FLAG, Fortholito::FALSE_FLAG]

  spec :greater_than, :code => %(
    1 2 >   2 1 >
  ), :expect => [Fortholito::FALSE_FLAG, Fortholito::TRUE_FLAG]

  ## ------------------------------------------ ARITHMENTICS

  spec :add_numbers, :code => %(
    1 2 3 4 + +
  ), :expect => [1, 9]

  spec :subtract_numbers, :code => %(
    0.5 10 -
  ), :expect => [9.5]

  spec :devide_numbers, :code => %(
    3 15 /
  ), :expect => [5]

  spec :multiply_numbers, :code => %(
    0.5 10 *
  ), :expect => [5]

  spec :modulo, :code => %(
    3 9 mod  3 10 mod
  ), :expect => [0, 1]

  ## ------------------------------------------ WORD DEFINITIONS

  spec :simple_word_definition, :expect => [2], :code => <<EOF
  : plus + ;
  1 1
  plus
EOF

  spec :longer_word_definition, 
       :expect => [Fortholito::TRUE_FLAG, Fortholito::FALSE_FLAG], 
       :code => <<EOF
  : multiple-of-3?
      3 swap
      mod
      0 =
  ;
  9 multiple-of-3?
  10 multiple-of-3?
EOF

  ## ------------------------------------------ IF ELSE THEN

  spec :if, :expect => [10], :code => <<EOF
    -1 if 10 else 20 then
EOF

  spec :else, :expect => [20], :code => <<EOF
    0 if 10 else 20 then
EOF

  spec :if_with_multiple_instructions, :expect => [4], :code => <<EOF
    -1 if 2 2 * else 20 then
EOF

  spec :if__multiline, :expect => [4], :code => <<EOF
    -1 if
          2 2 * 
       else 
          20 
       then
EOF

  spec :nested_if, :code => %(
    0 0 
       if              \\ 0 is not true, so will use other branch
          10 
       else 
          if           \\ second 0 obviously neither true
              if
                  20  
              else     
                  30
              then
          else
              40       \\ so the answer is here
          then 
       then
  ), 
  :expect => [40]

  ## ------------------------------------------ IF ELSE THEN

  spec :defining_word, 
    :code => 
    %( 
        : plusplus + + ;
        1 1 1 plusplus
     ), 
     :expect => [3]


  ## ------------------------------------------ ITERATIONS

  spec :begin_until, :code =>
  %(
      5                  \\ ( 5 )
      begin
          dup 1- dup     \\ ( 5 4 4 )
          0=             \\ ( 5 4 flag)
      until
  ),
  :expect => [5, 4, 3, 2, 1, 0]


  # TODO: spaces alias 
  # TODO: Looping
#  Variables: http://wiki.laptop.org/go/Forth_Lesson_6
  # TODO: File words
#  Multiline input in REPL - listen for error from build_ast
  # TODO: fload, save-forth,
  # xor
  # TODO in Fortholito:
  # 2+ not
end

FortholitoSpecification.new.execute
