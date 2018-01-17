
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "strangler"

Gem::Specification.new do |spec|
  spec.name          = "strangler"
  spec.version       = Strangler::VERSION
  spec.authors       = ["Michael Bell"]
  spec.email         = ["mbell@albionresearch.com"]

  spec.summary       = %q{Throttle executions of a block}
  spec.description   = %q{Throttle executionns of a block, e.g. to meet an API limit}
  spec.homepage      = "https://www.github.com/m-z-b/strangler"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end