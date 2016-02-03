# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "meta_programming"
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeff Patmon"]
  s.date = "2010-05-28"
  s.description = "Collection of meta-programming methods for Ruby"
  s.email = "jpatmon@gmail.com"
  s.homepage = "http://github.com/jeffp/meta_programming/tree/master"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubygems_version = "1.8.16"
  s.summary = "Collection of meta-programming methods for Ruby"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
