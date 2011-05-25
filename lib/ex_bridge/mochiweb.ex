module ExBridge::Mochiweb
  def request(request, options := {:})
    ExBridge::Mochiweb::Request.new(request, options)
  end

  def response(request, options := {:})
    ExBridge::Mochiweb::Response.new(request, options)
  end

  def websocket(_)
    self.error { 'nobridge, "No websocket support for Mochiweb" }
  end

  def start(options)
    if options.__parent_name__ == 'OrderedDict
      start(nil, options)
    else
      start(options, {:})
    end
  end

  def start(object, options)
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

    if options['websockets]
      websocket(nil)
    end

    Erlang.mochiweb_http.start options.to_list
  end
end