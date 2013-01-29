FORTHolito is a programming language - specifically an (incomplete) implementation of the [FORTH](http://en.wikipedia.org/wiki/Forth_%28programming_language%29) programming language - made just for fun and for the learning experience. The interpreter is implemented in Ruby, and it has an interactive REPL.

But it's more! It's my entry to the [PLT Games: Testing the Waters](http://www.pltgames.com/competition/2013/1) competition. I made it possible to write extensions to FORTHolito, and then wrote a **test extension**.

When you run FORTHolito with this extension all word you define **have to** include one or more tests - working examples of how the word operates.

Here's an example of a word definition in FORTHolito:

    : multiple-of? ( x n -- flag ) mod 0= ;

If I use the test extension however I would write it like this:

    : multiple-of? ( x n -- flag ) mod 0= 
      <EXAMPLE> given: 3 6  expect: true
      <EXAMPLE> given: 3 4  expect: false
    ;

FORTHolito (or FORTH basically) makes for some nice tests when all you do is operate on a data stack. The *givens* are just stack operations - *"given 3 and 6 are pushed onto the stack"*. What's left on the stack when the word has been called is the *expected* part.

###Try it out###

FORTHolito is a small and limited language. But if you're just curious about FORTH, or want to see how you can implement a simple language in Ruby, you should clone it and fire up the REPL. This is what you'll see:

    C:\dev\fortholito [master]> .\fortholito
    Welcome to FORTHolito version 0.2 by @tormaroe
    Type 'help' and hit [ENTER] to get started..
    ok

If you now type *help* you'll get a list of useful words to try out:

    ok  help
     SOME USEFULL WORDS YOU SHOULD TRY:
      words       \ display all words in the vocabulary
      describe    \ pop word (string) and show details
      .           \ pop and print the top item from the stack
      .s          \ display stack once
      showstack   \ toggle display of stack between commands
      stacktrace  \ display all modifications to stack for debugging
      help:stack  \ cheat sheet of stack overations
      bye         \ exit REPL
    ok

To get a feel for how much (or how little) of FORTH I've implemented in FORTHolito, type *words*:

    ok  words
     *                  +                  -                  -rot
     .                  .s                 /                  0<
     0<=                0<>                0=                 0>
     0>=                1+                 1-                 2*
     2/                 2drop              2dup               <
     <=                 <>                 =                  >
     >=                 abs                and                between
     bye                clear              cr                 depth
     describe           drop               dup                false
     help               help:stack         max                min
     mod                negate             nip                noop
     or                 over               push-range         rand
     rot                showstack          space              stacktrace
     swap               true               tuck               within
     words
    ok

As a treat to Ruby developers I've also made it possible to drop into Ruby inside strings.

    ok  "#{ 2 + 2 }"
    ok  "2 + 2 equals "
    ok  . . cr
    2 + 2 equals 4
    ok

###Final thoughs###

FORTHolito hasn't become all I hoped it would be. I had big plans for the test extension when I started - it would become this great, interactive development environment for producing perfectly tested and safe code.

The drive and passion I had in the beginning has dissipated for now. But it was great fun while it lasted - and maybe some day I'll pick up where I left off. Either way I did manage to enter into the [PLT Games](http://www.pltgames.com/competition/2013/1) again.
