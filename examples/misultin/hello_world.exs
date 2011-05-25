% This is a simple example of running Misultin with ExBridge.
% Notice that the code to start a given webserver is not
% agnostic, but the request interaction is.
%
% You can run this example from the repo root directoy:
%
%     elixir --no-halt -pa exbin examples/misultin/hello_world.exs
%
% And then access localhost:3000 in your browser.

module MisultinSample
  def handle_http(_request, response)
    response.serve_body! 200, { "Content-Type": "text/plain" }, "Hello world\n"
  end
end

% Boot

Code.prepend_path "deps/misultin/ebin"
{ 'ok, pid } = ExBridge::Misultin.start_link MisultinSample