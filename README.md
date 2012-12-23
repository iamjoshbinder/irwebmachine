__OVERVIEW__


| Project         | IRWebmachine   
|:----------------|:--------------------------------------------------
| Homepage        | https://github.com/generalassembly/irwebmachine
| Documentation   | http://rubydoc.info/gems/irwebmachine/frames
| Author          | General Assembly

__DESCRIPTION__

IRWebmachine is an interactive debugger you can use to make, trace & debug
HTTP requests destined for a [webmachine-ruby](https://github.com/seancribbs/webmachine-ruby)
resource. IRwebmachine is designed to be used inside a REPL such as Pry, but 
there is very basic IRB support as well. I recommend Pry for now, as IRB support
is unfinished & Pry offers some cool features for free.

__CONFIGURATION__

Copy the ruby code below into a project-local .pryrc file.
'MyApp' can be an instance of Webmachine::Application, or a subclass of 
Webmachine::Resource. It is used by irwebmachine when dispatching requests and 
it can be changed to another application or resource while in the REPL.


```ruby
require 'myapp'
require 'irwebmachine/pry'
IRWebmachine.app = MyApp
```

__USAGE__

todo

__PLATFORM SUPPORT__

  - CRuby 1.9+

__INSTALL__

    gem install irwebmachine

__LICENSE__

See LICENSE.txt
