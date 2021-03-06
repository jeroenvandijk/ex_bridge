module ExBridge::Mochiweb::Request
  mixin ExBridge::Request

  def request_method
    Erlang.apply(@request, 'get, ['method])
  end

  def path
    path_chars.to_bin
  end

  def path_chars
    raw_path = Erlang.apply(@request, 'get, ['raw_path])
    {path, _, _} = Erlang.mochiweb_util.urlsplit_path(raw_path)
    path
  end

  def query_params
    @query_params || begin
      list = Erlang.apply(@request, 'parse_qs, [])
      OrderedDict.from_list list.map(-> ({x,y}) { x.to_bin, y.to_bin })
    end
  end

  def post_params
    @post_params || begin
      list = Erlang.apply(@request, 'parse_post, [])
      OrderedDict.from_list list.map(-> ({x,y}) { x.to_bin, y.to_bin })
    end
  end

  def headers
    @headers || begin
      list = Erlang.mochiweb_headers.to_list(Erlang.apply(@request, 'get, ['headers]))
      list = list.map -> ({x,y}) { upcase_headers(x.to_char_list), y.to_bin }
      OrderedDict.from_list list
    end
  end

  def cookies
    @cookies || begin
      list = Erlang.apply(@request, 'parse_cookie, [])
      OrderedDict.from_list list.map(-> ({x,y}) { x.to_bin, y.to_bin })
    end
  end
end

