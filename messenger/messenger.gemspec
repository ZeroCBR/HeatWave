# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'messenger/version'

Gem::Specification.new do |spec|
  spec.name = 'messenger'
  spec.version = Messenger::VERSION
  spec.authors = ['Ned Pummeroy']
  spec.email = ['nedpummeroy@gmail.com']

  spec.summary = 'Sends weather warning messages to users.'
  spec.description = <<-EOF
    Uses ActiveRecord models to process weather, rule, location, and
    user data to determine what warnings need to be sent to people.
    Then sends the warnings using either email or sms, based on user
    preferences.
  EOF
  spec.homepage = "TODO: Put your gem's website or public repo URL here."

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    fail 'RubyGems 2.0 or newer is required to protect'\
         'against public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0")
    .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'

  spec.add_dependency 'active_record_migrations'
  spec.add_dependency 'sqlite3'
  spec.add_dependency 'sms_sender'
  spec.add_dependency 'mail'
end
