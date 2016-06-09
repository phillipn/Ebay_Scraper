class AddFieldsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :warranty, :string
    add_column :posts, :origin, :string
    add_column :posts, :brand, :string
    add_column :posts, :listing_type, :string
    add_column :posts, :manufacturer_part_number, :string
  end
end
