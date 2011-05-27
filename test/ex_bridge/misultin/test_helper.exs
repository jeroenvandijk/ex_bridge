Code.require_file "../../test_helper", __FILE__
Code.prepend_path "deps/misultin/ebin"

{ 'ok, _ } = ExBridge::Misultin.start_link HTTPServer,
  'name: 'misultin_test, 'port: 3002, 'docroot: File.expand_path("../..", __FILE__)