class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.integer :age
      t.integer :sex
      t.string :avatar_url
      t.boolean :is_admin

      t.timestamps
    end
  end
end
