# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "s3stamp/version"

Gem::Specification.new do |s|
  s.name                  = "s3stamp"
  s.version               = S3Stamp::Version::STRING
  s.platform              = Gem::Platform::RUBY
  s.required_ruby_version = ">= 1.9.3"
  s.authors               = ["Lucas Martins"]
  s.email                 = ["lucasmartins@railsnapraia.com"]
  s.homepage              = "http://rubygems.org/gems/s3stamp"
  s.summary               = "Quickly generate S3 signed URLs for upload and stuff."
  s.description           = s.summary
  s.license               = "LGPL-3.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  if RUBY_ENGINE=='rbx'
    s.add_dependency 'rubysl'
  end
  if RUBY_PLATFORM=='jruby'
    s.add_dependency 'jruby-openssl'
  end
  
  s.add_development_dependency "vcr"
  s.add_development_dependency "timecop"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-mocks"
  s.add_development_dependency "rspec-expectations"
  s.add_development_dependency "webmock", '>= 1.8.0', '< 1.16'
  s.add_development_dependency "rake"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-nav"
  s.add_development_dependency "yard"
end

