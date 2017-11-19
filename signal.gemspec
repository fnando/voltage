# frozen_string_literal: true

require "./lib/signal/version"

Gem::Specification.new do |gem|
  gem.name          = "signal"
  gem.version       = Signal::VERSION
  gem.authors       = ["Nando Vieira"]
  gem.email         = ["fnando.vieira@gmail.com"]
  gem.description   = "A simple observer implementation for POROs (Plain Old Ruby Object) and ActiveRecord objects."
  gem.summary       = gem.description
  gem.homepage      = "http://github.com/fnando/signal"

  gem.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  gem.executables   = gem.files.grep(%r{^bin/}).map {|f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "activerecord"
  gem.add_development_dependency "minitest-utils"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "sqlite3"
end
