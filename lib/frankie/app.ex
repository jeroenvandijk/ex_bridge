module Frankie::App
  module Routing
    % Adds a new route to the route set. The route object
    % only needs to respond to a `match?` which receives the
    % request object and to `call` which receives the application
    % (not instanciated yet), request and response objects.
    def route(route_object)
      update_ivar 'routes, _.push(route_object)
    end

    % Add a new route with a verb, path and the callback.
    def verb_route(verb, path, method)
      route(#Frankie::Routes::VerbRoute(verb, path, method))
    end

    def get(route, method)
      verb_route 'GET, route, method
    end

    def post(route, method)
      verb_route 'POST, route, method
    end

    def put(route, method)
      verb_route 'PUT, route, method
    end

    def patch(route, method)
      verb_route 'PATCH, route, method
    end

    def delete(route, method)
      verb_route 'DELETE, route, method
    end
  end

  attr_reader ['routes]

  def __mixed_in__(base)
    base.set_ivar('routes, [])
    base.using Frankie::App::Routing
  end

  def __bound__(request, response)
    @('request: request, 'response: response)
  end
end

