lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "cocoapods-{{name}}"
  spec.version       = File.read("VERSION").strip
  spec.authors       = ["Thuyen Trinh"]
  spec.email         = ["trinhngocthuyen@gmail.com"]
  spec.description   = "A CocoaPods plugin"
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/trinhngocthuyen/cocoapods-{{name}}"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "xcodeproj", ">= 1.23.0"
end
