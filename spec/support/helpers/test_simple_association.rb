# frozen_string_literal: true

class Symbol
  def to_nice_str
    to_s.tr('_', ' ')
  end
end

# Models Rspec
module Models
  # Has operations to validate a simple association
  module SimpleAssociationValidation
    def test_simple_association(assoc_sym, assoc_type_sym)
      describe 'Associations' do
        it "#{assoc_type_sym.to_nice_str} #{assoc_sym.to_nice_str}" do
          assoc = described_class.reflect_on_association(assoc_sym)
          expect(assoc.macro).to eq assoc_type_sym
        end
      end
    end
  end
end
