class RenamePictInUserVote < ActiveRecord::Migration
  def change
    rename_column :vote_options, :user_vote_pict, :vote_opt_pict
  end
end
