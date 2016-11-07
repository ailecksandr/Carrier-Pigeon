class AddTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :token, :string
  end
end
