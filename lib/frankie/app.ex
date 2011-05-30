module Frankie::App
  object Route
    attr_reader ['verb, 'route, 'method]

    def initialize(verb, route, method)
      @('verb: verb, 'route: route, 'method: method)
    end
  end

  object Wrapper
    def initialize(app)
      @('app, app)
    end

    def handle_http(request, response)
      
    end
  end

  module MixinMethods
    def __added_as_mixin__(base)
      base.set_ivar('routes, [])
    end

    def route(verb, route, method)
      route_object = Frankie::App::Route.new(verb, route, method)
      update_ivar('routes, _.push(route_object))
    end

    def get(route, method)
      route 'get, route, method
    end

    def post(route, method)
      route 'post, route, method
    end

    def put(route, method)
      route 'put, route, method
    end

    def patch(route, method)
      route 'patch, route, method
    end

    def delete(route, method)
      route 'delete, route, method
    end

    def run(server, options := {})
      options = options.set_new 'name, "Frankie_#{self.__name__}".to_atom
      wrapper = Frankie::App::Wrapper.new(self)
      ExBridge.start server, wrapper, options
    end
  end

  def __added_as_proto__(base)
    base.mixin(Frankie::App::MixinMethods)
  end
end