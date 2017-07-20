# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "kingfisher/version"

Gem::Specification.new do |spec|
  spec.name          = "kingfisher"
  spec.version       = Kingfisher::VERSION
  spec.authors       = ["Matthew Mongeau"]
  spec.email         = ["halogenandtoast@gmail.com"]

  spec.summary       = %q{A modular web framework with opinions}
  spec.description   = %q{A modular web framework with opinions}
  spec.homepage      = "https://github.com/halogenandtoast/kingfisher"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
