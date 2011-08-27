Code.require_file "../test_helper", __FILE__

module RouteTest
  mixin ExUnit::Case

  def match_route_test
    vr = #Frankie::Routes::VerbRoute('GET, "/some/route", nil)
    {} = vr.match_route('GET, "/some/route")
    false = vr.match_route('GET, "/some/other_route")
    false = vr.match_route('GET, "/")
    false = vr.match_route('POST, "/some/route")

    vr = #Frankie::Routes::VerbRoute('GET, "/'arg1/path/'arg2", nil)
    {'arg1: "hello", 'arg2: "world"} = vr.match_route('GET, "/hello/path/world")
    false = vr.match_route('POST, "/hello/path/world")
    false = vr.match_route('GET, "/hello/pathh/world")

    vr = #Frankie::Routes::VerbRoute('POST, "/'arg1/path/'arg2", nil)
    {'arg1: "hello", 'arg2: "world"} = vr.match_route('POST, "/hello/path/world")
    false = vr.match_route('GET, "/hello/path/world")
    false = vr.match_route('POST, "/hello/pathh/world")

    vr = #Frankie::Routes::VerbRoute('GET, "/*/*/*/'arg/*", nil)
    {'arg: "and", 'splat: ["1", "2", "3", "4"]} = vr.match_route('GET, "/1/2/3/and/4")
    false = vr.match_route('GET, "/1/2/3/and/4/5")
    false = vr.match_route('GET, "/1/2/3/and")
  end
end

