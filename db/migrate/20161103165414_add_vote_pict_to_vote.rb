class AddVotePictToVote < ActiveRecord::Migration
  def change
    add_column :votes, :vote_pict_url, :string
  end
end
