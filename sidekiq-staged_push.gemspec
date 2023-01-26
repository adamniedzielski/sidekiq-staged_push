# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sidekiq/staged_push/version"

Gem::Specification.new do |spec|
  spec.name          = "sidekiq-staged_push"
  spec.version       = Sidekiq::StagedPush::VERSION
  spec.authors       = ["Adam Niedzielski"]
  spec.email         = ["adamsunday@gmail.com"]

  spec.summary       = "Transactional job push for Sidekiq with jobs staged in the database"
  spec.homepage      = "https://github.com/adamniedzielski/sidekiq-staged_push"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.metadata = {
    "rubygems_mfa_required" => "true"
  }

  spec.required_ruby_version = ">= 2.7.5"

  spec.add_dependency "activerecord", ">= 5.2.0"
  spec.add_dependency "sidekiq", ">= 6.5.0", "<7"
end
