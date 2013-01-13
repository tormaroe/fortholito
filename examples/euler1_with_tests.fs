
: multiple-of? ( x n -- flag ) mod 0= 
  <EXAMPLE> given: 3 6  expect: true
  <EXAMPLE> given: 3 4  expect: false
;

: multiple-of-3? ( x -- flag ) 3 swap multiple-of? 
  <EXAMPLE> given: 3  expect: true
  <EXAMPLE> given: 6  expect: true
  <EXAMPLE> given: 9  expect: true
  <EXAMPLE> given: 1  expect: false
  <EXAMPLE> given: 4  expect: false
  <EXAMPLE> given: 8  expect: false
;
: multiple-of-5? ( x -- flag ) 5 swap multiple-of? 
  <EXAMPLE> given: 5   expect: true
  <EXAMPLE> given: 10  expect: true
  <EXAMPLE> given: 15  expect: true
  <EXAMPLE> given: 1  expect: false
  <EXAMPLE> given: 4  expect: false
  <EXAMPLE> given: 6  expect: false
;
: multiple-of-3-or-5? ( x -- flag )
    dup multiple-of-3? 
    swap multiple-of-5? 
    or
  <EXAMPLE> given: 3  expect: true
  <EXAMPLE> given: 5  expect: true
  <EXAMPLE> given: 15 expect: true
  <EXAMPLE> given: 1  expect: false
  <EXAMPLE> given: 8  expect: false
  <EXAMPLE> given: 13 expect: false
;

: euler1 ( min max -- sum )
    0                \ Accumulator (sum)
    begin
        -rot         ( sum min max )
        2dup <>      ( sum min max flag )
    while            \ while min <> max
        dup multiple-of-3-or-5? if
            rot          ( min max sum )
            over         ( min max sum max )
            1- -rot
            +            ( min max sum2 )
        else
            1- rot
        then
    repeat 
    2drop 

  <EXAMPLE> given: 0 10  expect: 33
  <EXAMPLE> given: 1 999 expect: 233168
;
            
: main 1 999 euler1 
    "Sum of multiples of 3 and 5 below 1000: " 
    . . cr 
  <EXAMPLE> \ expecting no change on stack!
;

"Write 'main' to calculate the answer to Project Euler problem #1" . cr
