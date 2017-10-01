class CreateCompetitors < ActiveRecord::Migration[5.1]
  def change
    create_table :competitors do |t|
      t.string :name
      t.string :link
      t.string :product_asin
      t.belongs_to :group, index: true

      t.timestamps
    end
  end
end
