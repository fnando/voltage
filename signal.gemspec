# frozen_string_literal: true

require "./lib/signal/version"

Gem::Specification.new do |spec|
  spec.name          = "signal"
  spec.version       = Signal::VERSION
  spec.authors       = ["Nando Vieira"]
  spec.email         = ["fnando.vieira@gmail.com"]
  spec.description   = %w[
    A simple observer implementation for POROs (Plain Old Ruby Object) and
    ActiveRecord objects.
  ].join(" ")
  spec.summary       = spec.description
  spec.homepage      = "http://github.com/fnando/signal"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.executables   = spec.files.grep(%r{^bin/}).map {|f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.post_install_message =
    "\n====================================================================\n" \
    "`signal` has been deprecated in favor of `voltage`.\n" \
    "To install it, use `gem install voltage` or add it to your gemfile.\n" \
    "For details, please visit https://github.com/fnando/signal/issues/6" \
    "\n====================================================================\n\n"

  spec.add_dependency "voltage"

  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "minitest-utils"
  spec.add_development_dependency "pry-meta"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-fnando"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "sqlite3"
end
