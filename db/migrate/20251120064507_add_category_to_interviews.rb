class AddCategoryToInterviews < ActiveRecord::Migration[7.1]
  def change
    add_column :interviews, :category, :string
  end
end
