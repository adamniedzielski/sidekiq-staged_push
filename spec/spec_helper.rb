# frozen_string_literal: true

require "bundler/setup"
require "sidekiq/staged_push"
require "active_record"
require "rails/generators"
require "database_cleaner/active_record"

db_directory = Pathname.new(File.expand_path("../db/", File.dirname(__FILE__)))
db_file = db_directory.join("test.sqlite3")

FileUtils.rm_f(db_file)

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: db_file
Rails::Generators.invoke("sidekiq:staged_push:install", ["--force"])
ActiveRecord::MigrationContext.new(db_directory.join("migrate"), ActiveRecord::SchemaMigration).migrate

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
