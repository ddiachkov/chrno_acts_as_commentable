# encoding: utf-8
$:.push File.expand_path( "../lib", __FILE__ )
require "acts_as_commentable/version"

Gem::Specification.new do |s|
  s.name        = "chrno_acts_as_commentable"
  s.version     = ActsAsCommentable::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = [ "Denis Diachkov" ]
  s.email       = [ "d.diachkov@gmail.com" ]
  s.homepage    = "https://github.com/ddiachkov/chrno_acts_as_commentable"
  s.summary     = "Adds acts_as_commentable behavior to AR models"

  s.files         = Dir[ "*", "lib/**/*" ]
  s.require_paths = [ "lib" ]

  s.add_runtime_dependency "rails", ">= 3.1"
  s.add_runtime_dependency "activerecord", ">= 3.1"
end