% This is a simple example of running Mochiweb with ExBridge.
% Notice that the code to start a given webserver is not
% agnostic, but the request interaction is.
%
% You can run this example from the repo root directoy:
%
%     elixir --no-halt -pa exbin examples/mochiweb/hello_world.exs
%
% And then access localhost:3000 in your browser.

module MochiwebSample
  def handle_http(_request, response)
    response.serve_body! 200, { "Content-Type": "text/plain" }, "Hello world\n"
  end
end

% Boot

Code.prepend_path "deps/mochiweb/ebin"
{ 'ok, pid } = ExBridge::Mochiweb.start MochiwebSample, 'name: 'mochiweb_sample,'port: 3000