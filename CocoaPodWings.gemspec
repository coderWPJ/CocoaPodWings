# coding: utf-8
lib = File.expand_path("../lib", __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "CocoaPodWings"
  spec.version       = "0.0.2"
  spec.authors       = "Wupengju"
  spec.email         = "331321408@qq.com"

  spec.summary       = %q{Efficiency improvement for iOS modular development with cocoa pods.}
  spec.description   = %q{Efficiency improvement for iOS modular development with cocoa pods.}
  spec.homepage      = "https://github.com/coderWPJ/CocoaPodWings.git"
  spec.license       = "MIT"

  spec.files = Dir['lib/**/*', 'bin/*'] + ['LICENSE']
  spec.executables   = %w{ wing }
  
  spec.require_paths = ["lib"]
end
