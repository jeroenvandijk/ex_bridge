Code.prepend_path "deps/mochiweb/ebin"

object MyApp
  proto Frankie::App

  get "/version", def
    "1.2.3"
  end

  get "/cookies/set", def (request, response)
    response = response.cookies.set("hello", "world")
    response = response.body("Cookie set")
    response
  end
  
  get "/cookies/read", def (request, response)
    "Cookie: #{request.cookies["hello"]}"
  end
end

MyApp.run 'mochiweb