# frozen_string_literal: true

# Amazon module
module Amazon
  # Communication exceptions
  class CommunicationError < StandardError; end
  # Exception for product not found on link
  class ProductNotFoundError < StandardError; end
  # Generic exception when parsing failed
  class ParseError < StandardError; end
end
