% This is a simple example of running Frankie with Mochiweb.
%
%     elixir --no-halt -pa exbin examples/mochiweb/frankie.exs
%
% And then access localhost:3000/hello_world in your browser.
Code.prepend_path "deps/mochiweb/ebin"

module MyApp
  mixin Frankie::App

  get "/hello_world", def
    "Hello World"
  end
end

MyApp.run 'mochiweb