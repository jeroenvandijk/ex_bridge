module ExBridge::Misultin
  mixin ExBridge::Driver

  def request(request, options := {:})
    ExBridge::Misultin::Request.new(request, options)
  end

  def response(request, options := {:})
    ExBridge::Misultin::Response.new(request, options)
  end

  def websocket(socket)
    ExBridge::Misultin::Websocket.new(socket)
  end

  def start(_object, _options)
    error { 'nobridge, "No start support for Mochiweb" }
  end

  def start_link(object, options)
    Erlang.misultin.start_link prepare_options(object, options).to_list
  end
end