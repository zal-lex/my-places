class CreatePlaces < ActiveRecord::Migration[6.0]
  def change
    create_table :places do |t|
      t.string :title
      t.text :description
      t.float :latitude
      t.float :longitude
      t.references :author, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
