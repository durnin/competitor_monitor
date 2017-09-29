# frozen_string_literal: true

# Group of Competitors model
class Group < ApplicationRecord
  # CONSTANTS
  MAX_NUMBER_OF_GROUPS = 10

  # VALIDATIONS
  validate :max_number_of_records, on: :create

  private

  def max_number_of_records
    current_group_count = Group.count
    return unless current_group_count >= MAX_NUMBER_OF_GROUPS
    errors[:base] << 'Tha maximum number of Groups of Competitors is '\
                     "#{MAX_NUMBER_OF_GROUPS} and current count is "\
                     "#{current_group_count}"
  end
end
