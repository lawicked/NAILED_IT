class CreateInterviews < ActiveRecord::Migration[7.1]
  def change
    create_table :interviews do |t|
      t.text :body
      t.string :target_role
      t.string :seniority
      t.string :language

      t.timestamps
    end
  end
end
