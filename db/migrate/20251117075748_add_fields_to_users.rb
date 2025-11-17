class AddFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :role, :string
    add_column :users, :techstack, :string
    add_column :users, :experience, :integer
  end
end
