# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mail_example/version'

Gem::Specification.new do |spec|
  spec.name          = "mail_example"
  spec.version       = MailExample::VERSION
  spec.authors       = ["Ned Pummeroy"]
  spec.email         = ["nedpummeroy@gmail.com"]

  spec.summary       = %q{Simple example for how to use the `mail` gem.}
  spec.description   = %q{
    A command line app which requests a sender gmail username and password,
    a recipient, and a message subject/body, then sends an email.
  }
  spec.homepage      = ""

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'localhost'
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "mail"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
