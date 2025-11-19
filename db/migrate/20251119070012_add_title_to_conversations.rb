class AddTitleToConversations < ActiveRecord::Migration[7.1]
  def change
    add_column :conversations, :title, :string
  end
end
