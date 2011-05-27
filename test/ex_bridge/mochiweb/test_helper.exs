Code.require_file "../../test_helper", __FILE__
Code.prepend_path "deps/mochiweb/ebin"

{ 'ok, _ } = ExBridge::Mochiweb.start HTTPServer,
  'name: 'mochiweb_test, 'port: 3001, 'docroot: File.expand_path("../..", __FILE__)
