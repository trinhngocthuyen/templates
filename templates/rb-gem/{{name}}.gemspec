lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "{{name}}"
  spec.version       = File.read("VERSION").strip
  spec.authors       = ["Thuyen Trinh"]
  spec.email         = ["trinhngocthuyen@gmail.com"]
  spec.description   = "A Ruby gem"
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/trinhngocthuyen/{{name}}"
  spec.license       = "MIT"

  spec.files         = Dir["{lib,bin}/**/*"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
