module Frankie
  % Start MyApp using the given *server* and *options*. Valid options are
  % 'port (defaults to 3000) and the process 'name (defaults to
  % Frankie-#{APP_NAME}).
  def run(server, app, options := {})
    options = options.set_new 'name, "Frankie-#{self.__module_name__}".to_atom
    wrapper = #Frankie::Routes::Wrapper(app)
    ExBridge.start server, wrapper, options
  end
end