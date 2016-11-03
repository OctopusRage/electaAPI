class CreateUserVoteLogs < ActiveRecord::Migration
  def change
    create_table :user_vote_logs do |t|
      t.integer :user_id
      t.integer :vote_option_before
      t.integer :vote_option_after
      t.integer :vote_id
      t.string :action

      t.timestamps null: false
    end
  end
end
