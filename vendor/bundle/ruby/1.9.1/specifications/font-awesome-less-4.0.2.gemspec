# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "font-awesome-less"
  s.version = "4.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Travis Chase"]
  s.date = "2013-11-04"
  s.description = "Font-Awesome LESS gem for use in Ruby on Rails projects"
  s.email = ["travis@travischase.me"]
  s.homepage = "https://github.com/FortAwesome/font-awesome-less"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.16"
  s.summary = "Font-Awesome LESS"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<less-rails>, [">= 2.4.2"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<less-rails>, [">= 2.4.2"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<less-rails>, [">= 2.4.2"])
  end
end
