__OVERVIEW__


| Project         | IRWebmachine   
|:----------------|:--------------------------------------------------
| Homepage        | https://github.com/generalassembly/irwebmachine
| Documentation   | http://rubydoc.info/gems/irwebmachine/frames
| Author          | General Assembly

__DESCRIPTION__

IRWebmachine is a collection of classes you can use to trace and debug your    
webmachine applications from a REPL like IRB or Pry. GET, POST, DELETE, &  
PUT requests can be made, the call stack of a request can be shown, and   
you can step inside any method on the call stack to inspect state at that   
point in the request. You can also step through a request as it happens,  
altering state to change the behavior of a resource.

IRWebmachine is still experimental and not ready for public release yet but it is  
definitely usable and useful. Design and implementation is still on going, and  
as soon as it feels ready a public release will come soon after.

__USAGE__

- [Pry (wiki)](https://github.com/generalassembly/irwebmachine/wiki/Pry)
- [IRB (wiki)](https://github.com/generalassembly/irwebmachine/wiki/irb)

__PLATFORM SUPPORT__

  - CRuby 1.9+

__LICENSE__

See LICENSE.txt

__TODO__

  - Wiki documentation for 'continue' command.

__INSTALL__

gem install irwebmachine
