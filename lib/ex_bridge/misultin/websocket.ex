module ExBridge::Misultin::Websocket
  mixin ExBridge::Websocket

  def send(message)
    Erlang.apply(@socket, 'send, [message.to_bin])
  end
end