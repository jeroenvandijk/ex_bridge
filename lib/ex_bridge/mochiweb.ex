module ExBridge::Mochiweb
  mixin ExBridge::Driver

  def request(request, options := {})
    ExBridge::Mochiweb::Request.new(request, options)
  end

  def response(request, options := {})
    ExBridge::Mochiweb::Response.new(request, options)
  end

  def websocket(_)
    error { 'nobridge, "No websocket support for Mochiweb" }
  end

  def start(object, options)
    Erlang.mochiweb_http.start prepare_options(object, options).to_list
  end

  def start_link(_object, _options)
    error { 'nobridge, "No start_link support for Mochiweb" }
  end

  def prepare_websockets(_object, options)
    if options['websockets]
      error { 'nobridge, "No websocket support for Mochiweb" }
    end

    options
  end
end