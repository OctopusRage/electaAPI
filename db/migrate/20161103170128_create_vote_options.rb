class CreateVoteOptions < ActiveRecord::Migration
  def change
    create_table :vote_options do |t|
      t.string :options
      t.references :vote, index: true, foreign_key: true
      t.string :user_vote_pict

      t.timestamps null: false
    end
  end
end
