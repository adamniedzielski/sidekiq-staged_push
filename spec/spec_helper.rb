# frozen_string_literal: true

require "bundler/setup"
require "sidekiq/staged_push"
require "active_record"
require "rails/generators"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
Rails::Generators.invoke("sidekiq:staged_push:install", ["--force"])
migrations_path = File.expand_path("../db/migrate/", File.dirname(__FILE__))
ActiveRecord::MigrationContext.new(migrations_path, ActiveRecord::SchemaMigration).migrate

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
