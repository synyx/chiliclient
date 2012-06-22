# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "chiliclient/version"

Gem::Specification.new do |s|
  s.name = "chiliclient"
  s.version = ChiliClient::VERSION
  s.authors = ["Fabian Buch"]
  s.email = ["buch@synyx.de"]
  s.homepage = "https://github.com/synyx/chiliclient"
  s.summary = "Commandline client that uses ChiliProject or Redmine REST API"
  s.description = ""

  s.files = Dir['[A-Z]*'] + Dir['{bin,lib,tasks,test}/**/*'] + [ 'chiliclient.gemspec' ]
  s.extra_rdoc_files = ['README.md']
  s.rdoc_options = [ '--main', 'README.md' ]
  s.executables = [ 'chili' ]
  s.require_paths = [ 'lib' ]

  s.add_runtime_dependency "cri", '~> 2.2'
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "highline"

  s.post_install_message = %q{------------------------------------------------------------------------------
run "chili help" for usage information
------------------------------------------------------------------------------
}
end
