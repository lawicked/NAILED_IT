class AddCurrentQuestionIndexToConversations < ActiveRecord::Migration[7.1]
  def change
    add_column :conversations, :current_question_index, :integer, default: 0
  end
end
