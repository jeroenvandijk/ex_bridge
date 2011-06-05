Code.prepend_path "deps/mochiweb/ebin"

module MyApp
  mixin Frankie::App

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

Frankie.run 'mochiweb, MyApp