# frozen_string_literal: true

RSpec.configure do |config|
  # :no_db is a tag to use on specs that don't depend on db (to speed up tests)
  config.before(:suite, no_db: false) do
    require 'database_cleaner'
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:example, no_db: false) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:example, no_db: false, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:example, no_db: false) do
    DatabaseCleaner.start
  end

  config.after(:example, no_db: false) do
    DatabaseCleaner.clean
  end
end
