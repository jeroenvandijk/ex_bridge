Code.require_file "../test_helper", __FILE__

module Misultin::ServerTest
  mixin ExUnit::Case
  mixin ServerCase

  def port
    3002
  end
end