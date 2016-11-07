class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :body
      t.string :password
      t.integer :destroy_type
      t.integer :destroy_value
    end
  end
end
