
  \ Demo FORTHolito program /
 \ by @tormaroe - 2013-01-04 /

: y  a "confusing"  "program" ;
: ¤                       " " ;
: '''     "s"       i       + ;
: -<>-   true      -x-     +? ;
: ===      y       =<>=       ; 
: =<>=    nip      nip        ;
: -x-     "e"  m  "weso"    a ;
: ?+            +          +? ;
: -/           "!"       -<>- ;
: m "m" ;  : i "i" ;  : a "a" ;
: +? over if nip else ?+ then ;
: foo if q|p  else  drop then ;
: This  -/  ¤ ''' ¤ === ¤  go ;
: q|p         quux    program ;
: bar      dup    0<>         ;
: quux   -rot +    swap 1-    ;
: si    cr             bye    ;
: go      '''     "Th"      8 ;
: program     bar         foo ;
: is           .           si ;
: awesome!  This  program  is ;
                               
           awesome!
