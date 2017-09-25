# frozen_string_literal: true

RSpec.configure do |config|
  config.when_first_matching_example_defined(type: :feature) do
    require 'capybara/rspec'
    require 'selenium/webdriver'

    Capybara.javascript_driver = :selenium_chrome_headless
  end
end
