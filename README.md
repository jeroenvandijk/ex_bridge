# ExBridge

The goal of this project is to provide an [Elixir](https://github.com/josevalim/elixir) bridge that can interact with different Erlang webservers. It is heavily influenced by [SimpleBridge](https://github.com/nitrogen/simple_bridge).

This repository also holds *Frankie*, a [Sinatra](https://github.com/sinatra/sinatra) like web framework for Elixir. It is being developed with ExBridge for convenience but will be split into different repositories when both projects become more stable.

## Examples

There are many examples in the examples directory. To run them, as Elixir was not released yet, you need to check out [Elixir's repository](https://github.com/josevalim/elixir) and put its `bin/` directory in your path. After that, you need to get all the dependencies by running the following inside this repo:

    elixir runner.exs setup

## ExBridge API

ExBridge has two main APIs: one for the request and other for the response object (and a websocket API is still in development). The request API is mainly for reading request information while the response contains information about the response to be returned to the client.

### Request API

* `request_method` - Returns an atom with the request method, for example `'GET`.
* `path` - Returns the request path, for example `"/foo/bar"`.
* `headers` - Returns all the headers given in the request as a Dict. Both keys and values are strings.
* `memoize!` - Returns a new object where headers and cookies are memoized.

### Response API

* `status` - Reads the currently set status code.
* `status(status)` - Sets the given *status* code.

* `headers` - Returns an object to manipulate headers:
    * `[](header)` - Reads the given *header*.
    * `merge(headers)` - Adds the given *headers* to the current set.
    * `clear` - Clears the current headers.
    * `delete(header)` - Removes the given *header* from the set.

* `cookies` - Returns an object to manipulate headers:
    * `[](key)` - Reads the cookie given by *key*.
    * `set(key, value, options := {:})` - Sets a cookie with *key*, *value* and given *options*.
    * `delete(key, options := {:})` - Removes the cookie given by *key*. Removing a cookie happens by setting its value to deleted and setting it expires date to 1970. All options given when creating a cookie must also be given when removing it.

    Cookie options can be *domain* (string), *path* (string), *expires* (datetime or string), *secure* (boolean) and *httponly* (boolean). All cookies are *httponly* by default.

* `query_params` - Returns the request's query parameters as a Dict.
* `post_params` - Returns the request's post parameters as a Dict.

* `body` - Read the currently set body.
* `body(body)` - Replaces the current body by the one given.

* `file` - Read the *filepath* currently set as response.
* `file(filepath)` - Return the file at *filepath* on respond.

* `set(status, headers, body)` - Respond to the client using the given *status*, *headers* and *body*. It ignores any previously set value.

All the methods above will return a new response object with the new values. In none of those cases the response is actually streamed back to the client. All the methods that send the information back to the client end with ! and should be used by framework developers and avoided in general by application developers.

* `dispatch!` - Stream the response back based on the values configured previously.
* `serve_body!(status, headers, body)` - Serve the given body with *status*, *headers* and *body*, ignoring previous values.
* `serve_file!(file, headers)` - Serve the given file with headers ignoring previously set values.

## Frankie

Frankie allows you to easily build simple web applications. Here is an example:

    module MyApp
      mixin Frankie::App
    
      get "/version", def
        "1.2.3"
      end
      
      get "/set_cookie", def
        response = response.cookies.set("hello", "world")
        response = response.body("Cookie set")
        response
      end
      
      get "/read_cookie", def
        "#{request.cookies["hello"]}"
      end
      
      get "/get_value_param", def
        "Query parameter \"value\" is: #{request.query_params["value"]}"
      end

      get "/multiply/'arg1/'arg2", def
        arg1 = params['arg1].to_i
        arg2 = params['arg2].to_i
        "#{arg1} * #{arg2} = #{arg1 * arg2}"
      end
    end
    
    Frankie.run 'mochiweb, MyApp

Ready to run examples are available at `examples/mochiweb/frankie.exs`.

## Running tests

You can run tests with:

    elixir runner.exs
    
## License

This project uses MIT-LICENSE.
