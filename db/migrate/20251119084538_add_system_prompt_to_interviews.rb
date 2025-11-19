class AddSystemPromptToInterviews < ActiveRecord::Migration[7.1]
  def change
    add_column :interviews, :system_prompt, :text
  end
end
