module ExBridge::Misultin::Request
  mixin ExBridge::Request

  def request_method
    Erlang.apply(@request, 'get, ['method])
  end

  def path
    path_chars.to_bin
  end

  def path_chars
    { 'abs_path, path } = Erlang.apply(@request, 'get, ['uri])
    path
  end

  def headers
    @headers || begin
      list = Erlang.apply(@request, 'get, ['headers])
      list = list.map -> ({x,y}) { upcase_headers(x), y.to_bin }
      OrderedDict.from_list list
    end
  end
end