# frozen_string_literal: true

require 'support/helpers/test_simple_association'

RSpec.configure do |config|
  config.extend Models::SimpleAssociationValidation, type: :model
end
