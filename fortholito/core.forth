
\ FORTHolito core words

: noop ( -- ) ;

: true  ( -- -1 ) -1 ;
: false ( --  0 )  0 ;

: 0< ( n -- flag ) 0 < ;
: 0= ( n -- flag ) 0 = ;
: 0> ( n -- flag ) 0 > ;

: 1+ ( n1 -- n2 ) 1 + ;
: 1- ( n1 -- n2 ) 1 swap - ;
: 2* ( n1 -- n2 ) 2 * ;
: 2/ ( n1 -- n2 ) 2 swap / ;

: negate ( n1 -- n2 ) -1 * ;

: nip  ( a b -- b ) swap drop ;
: tuck ( a b -- b a b ) swap over ; 
: 2dup ( a b -- a b a b ) over over ;
: 2drop ( a b -- ) drop drop ;
