Code.require_file "../test_helper", __FILE__

module Mochiweb::ServerTest
  mixin ExUnit::Case
  mixin ServerCase

  def port
    3001
  end
end