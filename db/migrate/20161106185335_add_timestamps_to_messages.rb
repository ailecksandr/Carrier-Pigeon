class AddTimestampsToMessages < ActiveRecord::Migration[5.0]
  def change
    change_table(:messages) { |t| t.timestamps }
  end
end
