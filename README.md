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
altering state to change the behavior of a request.

__USAGE__

__PRY__

Pry support can be added to any Pry console by requiring `irwebmachine/pry`.  
Once you have loaded Pry support, you can point irwebmachine at your webmachine  
app by setting `IRWebmachine.app`:

    IRWebmachine.app = My::Resource

An `app` object is exposed for you to use to make requests, a simple GET request  
might look something like this:

    app.get "/search", q: "rob"

Once you've made a request, you can print the call stack of the request:  

    [6] pry(main):2> print-stack
    
    0: #<Class:Webmachine::Resource>#new
    1: Webmachine::Resource::Callbacks#service_available?
    2: Webmachine::Resource::Callbacks#known_methods
    3: Webmachine::Resource::Callbacks#uri_too_long?
    … etc.


But you can go further, you can enter into a method on the stack and inspect its  
surrounding state at the point it was executed:

    [6] pry(main):2> enter-stack 3
    [6] pry(My::Resource):3> instance_variables
     => [:@request, :@response]
    [6] pry(My::Resource):4> __method__
     => :uri_too_long?

The enter-stack command imports the "next", and "prev" commands into your  
context so you can continue the execution of the request. The "next" command  
happens in real time, so if method B sets @foo but method A executes beforehand,  
@foo will not be visible to method A:

    [6] pry(main):2> enter-stack 3
    [6] pry(My::Resource):3> instance_varibles
    => [:@request, :@response]
    [6] pry(My::Resource):4> next
    [6] pry(My::Resource):5> instance_variables
    => [:@request, :@response, :@session]

__LICENSE__

See LICENSE.txt

__INSTALL__

gem install irwebmachine
