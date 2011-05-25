module ExBridge::Driver
  def start_link(options)
    if options.__parent_name__ == 'OrderedDict
      self.start_link(nil, options)
    else
      self.start_link(options, {:})
    end
  end

  def start(options)
    if options.__parent_name__ == 'OrderedDict
      self.start(nil, options)
    else
      self.start(options, {:})
    end
  end
  
  def prepare_options(object, options)
    options = options.set_new('port, 3000)
    options = self.prepare_http(object, options)
    options = self.prepare_websockets(object, options)
    options
  end

  def prepare_http(object, options)
    docroot = options['docroot]
    options = options.delete('docroot)

    if value = options['http]
      options.set('loop, value).delete('http)
    elsif object
      options.set 'loop, do (raw_request)
        req = self.request(raw_request)
        res = self.response(raw_request, 'docroot: docroot)
        object.handle_http(req, res)
      end
    else
      options
    end
  end

  def prepare_websockets(object, options)
    if object && options['websockets] == true
      options.set 'ws_loop, do (raw_socket)
        socket = self.websocket(raw_socket)
        object.handle_websocket(socket)
      end
    elsif value = options['websockets]
      options.set('ws_loop, value).delete('websockets)
    else
      options
    end
  end
end