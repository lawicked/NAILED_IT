class AddQuestionsToInterviews < ActiveRecord::Migration[7.1]
  def change
    add_column :interviews, :questions, :text
  end
end
