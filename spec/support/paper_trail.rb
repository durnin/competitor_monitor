# frozen_string_literal: true

RSpec.configure do |config|
  config.when_first_matching_example_defined(paper_trail: true) do
    require 'paper_trail/frameworks/rspec'
  end
end
