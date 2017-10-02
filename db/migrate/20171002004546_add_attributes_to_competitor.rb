class AddAttributesToCompetitor < ActiveRecord::Migration[5.1]
  def change
    add_column :competitors, :price_low, :decimal
    add_column :competitors, :price_high, :decimal
    add_column :competitors, :title, :string
    add_column :competitors, :images, :text
    add_column :competitors, :features, :text
    add_column :competitors, :number_of_reviews, :integer
    add_column :competitors, :best_seller_rank, :integer
    add_column :competitors, :inventory, :integer
  end
end
