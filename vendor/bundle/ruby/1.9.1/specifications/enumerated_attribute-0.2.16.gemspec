# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "enumerated_attribute"
  s.version = "0.2.16"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeff Patmon"]
  s.date = "2010-08-11"
  s.description = "Enumerated model attributes and view helpers"
  s.email = "jpatmon@gmail.com"
  s.homepage = "http://github.com/jeffp/enumerated_attribute/tree/master"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.16"
  s.summary = "Add enumerated attributes to your models and expose them in drop-down lists in your views"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<meta_programming>, [">= 0.2.1"])
    else
      s.add_dependency(%q<meta_programming>, [">= 0.2.1"])
    end
  else
    s.add_dependency(%q<meta_programming>, [">= 0.2.1"])
  end
end
