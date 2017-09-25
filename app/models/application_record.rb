# frozen_string_literal: true

# Rails ApplicationRecord Class
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
