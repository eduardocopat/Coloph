# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "twitter-bootstrap-rails-confirm"
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rene van Lieshout"]
  s.date = "2013-10-11"
  s.description = "Confirm dialogs using Twitter Bootstrap"
  s.email = ["rene@bluerail.nl"]
  s.homepage = "https://github.com/bluerail/twitter-bootstrap-rails-confirm"
  s.require_paths = ["lib", "vendor"]
  s.rubygems_version = "1.8.16"
  s.summary = "Applies a custom confirm dialog for elements with a data-confirm attribute."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
