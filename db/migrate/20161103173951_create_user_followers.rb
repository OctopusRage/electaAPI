class CreateUserFollowers < ActiveRecord::Migration
  def change
    create_table :user_followers do |t|
      t.integer :follower_id
      t.integer :following_id

      t.timestamps null: false
    end
  end
end
