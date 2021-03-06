
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "strangler"

Gem::Specification.new do |spec|
  spec.name          = "strangler"
  spec.version       = Strangler::VERSION
  spec.authors       = ["Mike Bell"]
  spec.email         = ["mbell@albionresearch.com"]

  spec.summary       = %q{Throttle executions of a block}
  spec.description   = %q{Throttle executions of a block, e.g. to meet an external API rate limit}
  spec.homepage      = "https://www.github.com/m-z-b/strangler"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
