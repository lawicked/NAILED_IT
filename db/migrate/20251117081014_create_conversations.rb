class CreateConversations < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations do |t|
      t.datetime :start_time
      t.references :user, null: false, foreign_key: true
      t.references :interview, null: false, foreign_key: true

      t.timestamps
    end
  end
end
