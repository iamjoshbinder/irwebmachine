__OVERVIEW__


| Project         | IRWebmachine   
|:----------------|:--------------------------------------------------
| Homepage        | https://github.com/generalassembly/irwebmachine
| Documentation   | http://rubydoc.info/gems/irwebmachine/frames
| Author          | General Assembly

__DESCRIPTION__

IRWebmachine is an interactive debugger you can use to trace and debug
requests made to a [webmachine-ruby](https://github.com/seancribbs/webmachine-ruby)
resource. IRwebmachine is designed to be used inside a REPL such as Pry, but 
there is basic IRB support as well. It should be straight forward to add 
support for other REPLs if you want to.

__FEATURES__

The three cool features of the debugger might be:

  - The ability to step inside a method on the call stack after a request has 
    happened. This can be useful if you'd like to inspect the state of a 
    resource after a request. You can jump into any method on the call stack.
    
  - The ability to step through each method on the call stack as a request is 
    happening. This one is great if you want to inspect state in "real time", as 
    a request happens.

  - The ability to print the call stack for a resource after a request has 
    happened. This can be very useful if you want to visualuze the path your 
    webmachine resource took.

__USAGE__

- [Pry (wiki)](https://github.com/generalassembly/irwebmachine/wiki/Pry)

__PLATFORM SUPPORT__

  - CRuby 1.9+

__INSTALL__

    gem install irwebmachine

__LICENSE__

See LICENSE.txt
