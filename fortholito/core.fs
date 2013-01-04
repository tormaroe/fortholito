
\ -----------------------------------------
\ --------- FORTHolito core words ---------
\ -----------------------------------------

\ ==================== STANDARD FORTH WORDS

: noop ( -- ) ;

: true  ( -- -1 ) -1 ;
: false ( --  0 )  0 ;

: <> ( n1 n2 -- flag )
  = if false else true then
;

: <= ( n1 n2 -- flag ) 
  2dup                  ( n1 n2 n1 n2)
  <                     ( n1 n2 flag)
  rot rot               ( flag n1 n2)
  =                     ( flag flag )
  or                    ( flag )
;

: >= ( n1 n2 -- flag ) 
  2dup                  ( n1 n2 n1 n2)
  >                     ( n1 n2 flag)
  rot rot               ( flag n1 n2)
  =                     ( flag flag )
  or                    ( flag )
;

: 0<  ( n -- flag ) 0 <  ;
: 0<= ( n -- flag ) 0 <= ;
: 0=  ( n -- flag ) 0 =  ;
: 0<> ( n -- flag ) 0 <> ;
: 0>= ( n -- flag ) 0 >= ;
: 0>  ( n -- flag ) 0 >  ;

: nip  ( a b -- b ) swap drop ;
: tuck ( a b -- b a b ) swap over ; 
: 2dup ( a b -- a b a b ) over over ;
: 2drop ( a b -- ) drop drop ;
: -rot ( a b c -- c a b ) rot rot ;

: between  ( n low high -- flag )  \ True if low <= n <= high
  rot dup               ( low high n n )
  rot                   ( low n n high )
  <=                    ( low n flag   )
  -rot                  ( flag low n   )
  <=                    ( flag flag    )
  and                   ( flag         )
;
: within   ( n low high -- flag )  \ True if low <= n <  high
  rot dup               ( low high n n )
  rot                   ( low n n high )
  <                     ( low n flag   )
  -rot                  ( flag low n   )
  <=                    ( flag flag    )
  and                   ( flag         )
;

: 1+ ( n1 -- n2 ) 1 + ;
: 1- ( n1 -- n2 ) 1 swap - ;
: 2* ( n1 -- n2 ) 2 * ;
: 2/ ( n1 -- n2 ) 2 swap / ;

: negate ( n1 -- n2 ) -1 * ;  \ \\\\\\\ NOT SURE IF THIS IS CORRECT 
: abs    ( n1 -- n2 )
    dup 0< if negate then
;
: min ( n1 n2 -- n )
    2dup > if
        swap
    then drop
;
: max ( n1 n2 -- n )
    2dup < if
        swap
    then drop
;


\ =================== FORTHolito INVENTIONS

: push-range ( from to -- [n] )
    2dup                   ( from to from to ) 
    <> if                  ( from to         )
         over              ( from to from    )
         1+ swap           ( from from+1 to  )
         push-range        \   .. recur ..
       else
         2drop             ( [from..to] to to -- [from..to] )
       then
;


