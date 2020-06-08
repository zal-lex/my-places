class CreateFavPlaces < ActiveRecord::Migration[6.0]
  def change
    create_table :fav_places do |t|
      t.string :likeable_type
      t.references :user, null: false, foreign_key: { to_table: :users, on_delete: :cascade }
      t.references :likeable, null: false, foreign_key: { to_table: :places, on_delete: :cascade }

      t.timestamps
    end
    add_index :fav_places, [:user_id, :likeable_id, :likeable_type], unique: true
  end
end