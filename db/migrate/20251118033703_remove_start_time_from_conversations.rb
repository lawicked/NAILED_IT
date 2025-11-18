class RemoveStartTimeFromConversations < ActiveRecord::Migration[7.1]
  def change
     remove_column :conversations, :start_time, :datetime
  end
end
