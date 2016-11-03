class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.integer :rewarder_id
      t.string :rewarder_type
      t.string :description
      t.string :reward_type
      t.string :reward_pict_url

      t.timestamps null: false
    end
  end
end
