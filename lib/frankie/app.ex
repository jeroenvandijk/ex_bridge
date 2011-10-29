module Frankie::App
  module Routing

    % Add a new route with a verb, path and the callback.
    def verb_route(verb, path, method)
      % Unfortunately we cannot pass the method as a reference to the module_eval so 
      % we need to save it in a dictionary, is there another way?
      route_identifier = verb.to_s + path
      update_ivar 'routes, _.set(route_identifier, method)

      % TODO instead of just matching on the path we should also incorporate
      % splats and possible other restrictions

      module_eval __FILE__, __LINE__ + 1, ~~METHOD
        def handle_http('#{verb}, "#{path}", request)
          @routes["#{route_identifier}"].apply_to(self, [])
        end
~~

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

  attr_reader ['routes, 'request, 'response, 'params]

  def __mixed_in__(base)
    base.set_ivar('routes, {})
    base.using Frankie::App::Routing
  end

  def __bound__(request, response, params)
    @('request: request, 'response: response, 'params: params)
  end
end

