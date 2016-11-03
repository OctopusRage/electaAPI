class AddStatusToVote < ActiveRecord::Migration
  def change
    add_column :votes, :status, :string, default: 'open'
  end
end
