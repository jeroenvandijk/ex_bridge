object ExBridge::Misultin::Response
  proto ExBridge::Response

  def serve_body!(status, headers, body)
    response = [ status, convert_headers(headers), body.to_bin ]
    Erlang.apply(@request, 'respond, response)
    status
  end

  def serve_file!(path, headers := {:})
    serve_file_conditionally path, do
      Erlang.apply(@request, 'file, [File.join(@docroot, path).to_bin, convert_headers(headers)])
    end
  end

  private

  def convert_headers(headers)
    headers.to_list.map -> ({key, value}) {key.to_char_list, value.to_char_list}
  end
end