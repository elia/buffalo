# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'buffalo/version'

Gem::Specification.new do |s|
  s.name        = 'buffalo'
  s.version     = Buffalo::VERSION
  s.authors     = ['Elia Schito']
  s.email       = ['perlelia@gmail.com']
  s.homepage    = ''
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = 'buffalo'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  
  s.add_runtime_dependency 'tilt'
  s.add_runtime_dependency 'haml'
  s.add_runtime_dependency 'sass'
  s.add_runtime_dependency 'pdfkit'
  s.add_runtime_dependency 'watchr'
end
