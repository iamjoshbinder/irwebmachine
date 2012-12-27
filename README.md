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

- Making requests

  The first thing you'll probably want to do is make a request to a resource.
  GET, POST, DELETE & PUT requests can be made through the 'app' method.
  The example illustrates how to make a GET request:

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
            @trace=[]
            >

- Tracing 

  After you have made a request you can visualize what methods were called(and
  in what order) through the `print-stack` command:

        [2] pry(main)> print-stack                                                                                   0: #<Class:Webmachine::Resource>#new
         1: Webmachine::Resource::Callbacks#service_available?
         2: Webmachine::Resource::Callbacks#known_methods
         3: Webmachine::Resource::Callbacks#uri_too_long?
         4: Resource#allowed_methods
         …
        31: Resource#finish_request

  The output can be filtered, see `print-stack -h` for more information.

- Debugging

  You can jump inside any method on the call stack through the 'enter-stack' 
  command. It accepts a breakpoint as an argument, but it is optional.
    
        [3] pry(main)> enter-stack                                                                                  From: /Users/rob/.rbenv/…

        => 36: def self.new(request, response)
           37:   instance = allocate
           38:   instance.instance_variable_set(:@request, request)
           39:   instance.instance_variable_set(:@response, response)
           40:   instance.send :initialize
           41:   instance
           42: end

  The stack can be navigated through the 'continue', 'next', and 'previous' 
  commands. The call stack is navigated in 'real time'. In other words, 
  if you are in 'method A' but 'method B' has yet to be called you should 
  not see any state set by 'method B' until you step through it.

__PLATFORM SUPPORT__

  - CRuby 1.9+

__INSTALL__

    gem install irwebmachine

__LICENSE__

See LICENSE.txt
