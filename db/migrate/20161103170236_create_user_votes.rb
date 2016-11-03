class CreateUserVotes < ActiveRecord::Migration
  def change
    create_table :user_votes do |t|
      t.references :user, index: true, foreign_key: true
      t.references :vote_option, index: true, foreign_key: true
      t.references :vote, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
