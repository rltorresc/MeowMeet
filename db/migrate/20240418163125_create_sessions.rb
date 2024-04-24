class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.integer :user_id, null: false
      t.string :session_token, null: false
      t.timestamps
    end
  end
end
