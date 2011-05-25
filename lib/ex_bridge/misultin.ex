module ExBridge::Misultin
  def request(request, options := {:})
    ExBridge::Misultin::Request.new(request, options)
  end

  def response(request, options := {:})
    ExBridge::Misultin::Response.new(request, options)
  end

  def websocket(socket)
    ExBridge::Misultin::Websocket.new(socket)
  end

  def start_link(options)
    if options.__parent_name__ == 'OrderedDict
      start_link(nil, options)
    else
      start_link(options, {:})
    end
  end

  def start_link(object, options)
    options = options.set_new('port, 3000)

    docroot = options['docroot]
    options = options.delete('docroot)
    
    options = if value = options['http]
      options.set('loop, value).delete('http)
    elsif object
      options.set 'loop, do (raw_request)
        req = request(raw_request)
        res = response(raw_request, 'docroot: docroot)
        object.handle_http(req, res)
      end
    else
      options
    end

    options = if object && options['websockets] == true
      options.set 'ws_loop, do (raw_socket)
        socket = websocket(raw_socket)
        object.handle_websocket(socket)
      end
    elsif value = options['websockets]
      options.set('loop, value).delete('websockets)
    else
      options
    end

    Erlang.misultin.start_link options.to_list
  end
end