FORTHolito is

* A programming language
* .. specifically an implementation of the [FORTH](http://en.wikipedia.org/wiki/Forth_%28programming_language%29) programming language
* .. or actually a modern, higher level dialect
* .. implemented in Ruby
* .. because programming is fun

But it might become more! I'm planning an extension to the language making it a powerfull TDD environment promoting safe and bugfree software. Then I'll enter it into the [PLT Games: Testing the Waters](http://www.pltgames.com/competition/2013/1) competition.

Here's a log from the FORTHolito REPL showing the creation and evaluation of a HelloWorld "program":

    C:\dev\fortholito [master]> .\fortholito
    Welcome to FORTHolito version 0.2 by @tormaroe
    Type 'help' and hit [ENTER] to get started..
    ok  : HelloWorld ( -- ) "hello, world" . cr ;
    ok  HelloWorld
    hello, world
    ok  bye

