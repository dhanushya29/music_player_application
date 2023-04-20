class AddColumnToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :username, :string
    add_column :users, :phone, :bigint
  end
end
