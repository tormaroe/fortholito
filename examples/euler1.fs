
: multiple-of? ( x n -- flag ) mod 0= ;

: multiple-of-3? ( x -- flag ) 3 swap multiple-of? ;
: multiple-of-5? ( x -- flag ) 5 swap multiple-of? ;

: multiple-of-3-or-5? ( x -- flag )
    dup multiple-of-3? 
    swap multiple-of-5? 
    or ;

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
    2drop ;
            
: main 1 999 euler1 
    "Sum of multiples of 3 and 5 below 1000: " 
    . . cr ;

"Write 'main' to calculate the answer to Project Euler problem #1" . cr
