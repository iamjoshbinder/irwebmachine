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

- requests

  The first thing you'll probably want to do is make a request to a resource. 
  This can be done through the 'app' method:

      [1] pry(main)> app.get "/"
      => #<Webmachine::Response:0x007faa44143980
          @body="GET OK",
          @code=200,
          @headers=
            {"Content-Type"=>"plain/text",
            "Content-Length"=>"6",
            "X-Request-Query"=>{},
            "X-Request-Headers"=>{}},
          @redirect=false,
          @trace=[]>

- tracing 

todo

- debugging

todo

__PLATFORM SUPPORT__

  - CRuby 1.9+

__INSTALL__

    gem install irwebmachine

__LICENSE__

See LICENSE.txt
