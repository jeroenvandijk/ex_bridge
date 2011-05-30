module ExBridge
  def start(server, object, options)
    case server
    match 'mochiweb
      ExBridge::Mochiweb.start object, options
    match 'misultin
      ExBridge::Misultin.start_link object, options
    end
  end
end