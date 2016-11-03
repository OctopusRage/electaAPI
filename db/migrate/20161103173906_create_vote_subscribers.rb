class CreateVoteSubscribers < ActiveRecord::Migration
  def change
    create_table :vote_subscribers do |t|
      t.references :vote, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
